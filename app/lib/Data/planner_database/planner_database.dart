import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/Data/Planner/AbsentTime.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Data/Planner/Notes.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/planner_database/planner_connections.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/SchoolReport.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/grades/grade_span_package.dart';
import 'package:schulplaner8/groups/src/gateway/course_gateway.dart';
import 'package:schulplaner8/groups/src/gateway/school_class_gateway.dart';
import 'package:schulplaner8/groups/src/models/place.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner8/holiday_database/logic/holiday_gateway.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

import 'build_single_map.dart';
import 'planner_connections_state.dart';
import 'planner_database_data_manager.dart';

class PlannerDatabase {
  final String uid;
  final String plannerid;

  bool isDestroyed = false;
  late DocumentReference _rootplanner;
  final FirebaseFirestore root = FirebaseFirestore.instance;

  late DataDocumentPackage<PlannerSettingsData> settings;
  late DataDocumentPackage<PlannerConnections> connections;
  late DataCollectionPackage<Teacher> teachers;
  late DataCollectionPackage<Place> places;
  late DataCollectionPackage<CloudFile> personalfiles;
  late DataCollectionPackage<NoteData> notes;
  late DataCollectionPackage<AbsentTime> absentTime;
  late DataCollectionPackage<Grade> grades;
  late DataCollectionPackage<SchoolReport> schoolreports;
  late DataCombinedPackageSpecial<Course, CoursePersonal> courseinfo;
  late DataCombinedPackage<LessonInfo> lessoninfos;
  late DataCombinedPackage<SchoolTask> tasks;
  late DataCombinedPackage<Letter> letters;
  late DataCombinedPackage<SchoolEvent> events;
  late DataCombinedPackage<SchoolClass> schoolClassInfos;
  late DataCombinedPackage<Holiday> vacations;
  late PlannerConnectionsState connectionsState;
  late GradeSpanPackage gradespanpackage;
  late HolidayGateway holidayGateway;

  late DataManager dataManager;
  DocumentReference getRootReference() => _rootplanner;

  String getMemberId() => dataManager.getMemberId();

  MemberId getMemberIdObject() => dataManager.getMemberIdObject();

  PlannerSettingsData getSettings() =>
      settings.data ?? PlannerSettingsData.fromData(null);

  final Map<String, Map<String, Lesson>> oldlessondata = {};

  final Map<String, List<StreamSubscription>> _courselistener = {};
  final Map<String, List<StreamSubscription>> _classlistener = {};

  final List<StreamSubscription> _otherlistener = [];
  String? _loadedvacationpackageid;

  void requestCourseLink(String courseID) {
    FirebaseDatabase.instance
        .reference()
        .child('requests/incoming')
        .push()
        .set({'type': 'no_course_link', 'userID': uid, 'courseID': courseID});
  }

  void requestClassLink(String classID) {
    FirebaseDatabase.instance
        .reference()
        .child('requests/incoming')
        .push()
        .set({'type': 'no_class_link', 'userID': uid, 'classID': classID});
  }

  CourseGateway get courseGateway => CourseGateway(
        root,
        getMemberIdObject(),
      );

  SchoolClassGateway get schoolClassGateway => SchoolClassGateway(
        root,
        getMemberIdObject(),
      );

  PlannerDatabase({
    required this.uid,
    required this.plannerid,
    required AppSettingsBloc appSettingsBloc,
  }) {
    dataManager = DataManager(
      plannerid: plannerid,
      uid: uid,
    );
    _rootplanner =
        root.collection('users').doc(uid).collection('planner').doc(plannerid);
    settings = DataDocumentPackage(
        reference: _rootplanner.collection('data').doc('settings'),
        objectBuilder: (key, value) => PlannerSettingsData.fromData(value),
        directlyLoad: true,
        loadNullData: true);
    courseinfo = DataCombinedPackageSpecial<Course, CoursePersonal>(
        getKey: (it) => it.id,
        getKeySecondary: (it) => it.courseid,
        dataCreator: (item, secondary) {
          if (item == null) return null;
          return item.copyWithNull(
            personaldesign: secondary?.design,
            personalshortname: secondary?.shortname,
            personalgradeprofile: secondary?.gradeprofileid,
          );
        });
    _rootplanner.collection('data').doc('coursepersonal').snapshots().listen(
      (snapshot) {
        final data = snapshot.data();
        if (data != null) {
          data.forEach((key, value) {
            CoursePersonal coursePersonal =
                CoursePersonal.fromData(value?.cast<String, dynamic>());
            courseinfo.updateDataSecondary(coursePersonal, ChangeType.MODIFIED);
          });
        }
      },
    );
    tasks = DataCombinedPackage(getKey: (it) => it.taskid!);
    letters = DataCombinedPackage(getKey: (it) => it.id);
    events = DataCombinedPackage(getKey: (it) => it.eventid!);
    lessoninfos = DataCombinedPackage(getKey: (it) => it.id!);
    schoolClassInfos = DataCombinedPackage(getKey: (it) => it.id);
    connections = DataDocumentPackage(
        reference: dataManager.plannerConnections,
        objectBuilder: (key, value) => PlannerConnections.fromData(value),
        directlyLoad: true,
        loadNullData: true);
    connectionsState = PlannerConnectionsState(
      connections: connections,
      addToDB: _onCourseAdded,
      removeToDB: _onCourseRemoved,
      addClassToDB: _onSchoolClassAdded,
      removeClassToDB: _onSchoolClassRemoved,
    );
    teachers = DataCollectionPackage(
        reference: dataManager.teachersRef,
        objectBuilder: (key, it) => Teacher.fromData(it),
        getKey: (it) => it.teacherid,
        sorter: (item1, item2) {
          return (item1.name ?? '').compareTo(item2.name ?? '');
        });
    places = DataCollectionPackage(
        reference: dataManager.placesRef,
        objectBuilder: (key, it) => Place.fromData(it!),
        getKey: (it) => it.placeid,
        sorter: (item1, item2) {
          return (item1.name ?? '').compareTo(item2.name ?? '');
        });
    notes = DataCollectionPackage(
      reference: dataManager.notesRef.where('archived', isEqualTo: false),
      objectBuilder: (key, it) => NoteData.fromData(it!),
      getKey: (it) => it.noteid!,
    );
    personalfiles = DataCollectionPackage(
      reference: dataManager.filesPersonalRef,
      objectBuilder: (key, it) => CloudFile.fromData(it),
      getKey: (it) => it.fileid!,
      sorter: (i1, i2) => (i1.name ?? '').compareTo(i2.name ?? ''),
    );
    grades = DataCollectionPackage(
        reference: dataManager.gradesRef,
        objectBuilder: (key, it) => Grade.fromData(it!),
        getKey: (it) => it.id!,
        sorter: (item1, item2) {
          return (item1.date ?? '').compareTo(item2.date ?? '');
        });
    absentTime = DataCollectionPackage(
      reference: dataManager.absentTimeRef,
      objectBuilder: (key, it) => AbsentTime.fromData(it!),
      getKey: (it) => it.id,
    );
    schoolreports = DataCollectionPackage(
      reference: dataManager.schoolReportsRef,
      objectBuilder: (key, it) => SchoolReport.fromData(it!),
      getKey: (it) => it.id,
    );
    holidayGateway = HolidayGateway(root, HolidayCacheManager());
    vacations = DataCombinedPackage(getKey: (it) => it.id.key);
    _otherlistener.add(
      dataManager
          .getTaskRefPrivate()
          .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
          .snapshots()
          .listen(
        (snapshot) {
          snapshot.docChanges.forEach(
            (change) {
              tasks.updateData(SchoolTask.fromData(change.doc.data()!),
                  fromDocumentChange(change.type));
            },
          );
        },
      ),
    );
    _otherlistener.add(
      dataManager
          .getEventRefPrivate()
          .where('date', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
          .snapshots()
          .listen(
        (snapshot) {
          snapshot.docChanges.forEach(
            (change) {
              events.updateData(SchoolEvent.fromData(change.doc.data()!),
                  fromDocumentChange(change.type));
            },
          );
        },
      ),
    );
    _otherlistener.add(settings.stream.listen((plannersettingsdata) {
      String? newvacationpackageid = plannersettingsdata?.vacationpackageid;
      if (newvacationpackageid != _loadedvacationpackageid) {
        if (_loadedvacationpackageid != null) {
          vacations.removeWhere((it) => it.isFromDatabase == true);
        }
        _loadedvacationpackageid = newvacationpackageid;
        if (newvacationpackageid != null) {
          holidayGateway.loadHolidays(newvacationpackageid).then((holidays) {
            if (holidays != null) {
              for (final holiday in holidays) {
                vacations.updateData(holiday, ChangeType.ADDED);
              }
            }
          });
        }
      }
    }));
    _otherlistener.add(dataManager.vacationsRef.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        vacations.updateData(
            HolidayConverter.fromJson(change.doc.data(), false),
            fromDocumentChange(change.type));
      });
    }));
    gradespanpackage = GradeSpanPackage(appSettingsBloc, settings);
  }

  void forceUpdateHolidayDatabase() async {
    String? regionID = settings.data?.vacationpackageid;
    if (regionID == null) return;
    List<Holiday>? holidays =
        await holidayGateway.loadHolidaysForceRefresh(regionID);
    if (holidays != null) {
      if (_loadedvacationpackageid != null) {
        vacations.removeWhere((it) => it.isFromDatabase == true);
      }
      for (final holiday in holidays) {
        vacations.updateData(holiday, ChangeType.ADDED);
      }
    }
  }

  void onDestroy() {
    settings.close();
    isDestroyed = true;
  }

  bool isClosed() {
    return isDestroyed;
  }

  void _onCourseAdded(String courseid) {
    List<StreamSubscription> mCourseListeners = [];
    mCourseListeners
        .add(dataManager.getCourseInfo(courseid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        courseinfo.updateData(
          Course.fromData(snapshot.data()!),
          ChangeType.MODIFIED,
        );
      } else {
        courseinfo.removeWhere((item) => item.id == snapshot.id);
      }
    }));
    mCourseListeners.add(dataManager
        .getTaskRefCourse(courseid)
        .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      print(snapshot.docs.map((e) => (e.data())));
      snapshot.docChanges.forEach((change) {
        tasks.updateData(SchoolTask.fromData(change.doc.data()!),
            fromDocumentChange(change.type));
      });
    }));
    mCourseListeners.add(
        dataManager.getLessonRefCourse(courseid).snapshots().listen((snapshot) {
      oldlessondata[courseid] = snapshot.docs
          .map((snap) => Lesson.fromData(id: snap.id, data: snap.data()))
          .toList()
          .asMap()
          .map(((_, value) => MapEntry(value.lessonid!, value)));
      courseinfo.notifyDataSetChanged();
    }));
    mCourseListeners.add(dataManager
        .getEventRefCourse(courseid)
        .where('date', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        events.updateData(SchoolEvent.fromData(change.doc.data()!),
            fromDocumentChange(change.type));
      });
    }));
    mCourseListeners.add(dataManager
        .getLessonInfoRefCourse(courseid)
        .where('date', isGreaterThanOrEqualTo: getDateOneWeekAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        lessoninfos.updateData(
          LessonInfo.fromData(change.doc.data()!),
          fromDocumentChange(change.type),
        );
      });
    }));
    mCourseListeners.add(dataManager
        .getLetterRefCourse(courseid)
        .where('deleted', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        letters.updateData(
          Letter.FromData(change.doc.data()),
          fromDocumentChange(change.type),
        );
      });
    }));
    _courselistener[courseid] = mCourseListeners;
  }

  void _onCourseRemoved(String courseid) {
    _courselistener[courseid]?.forEach((it) => it.cancel());
    _courselistener.remove(courseid);
    courseinfo.removeWhere((info) => info.id == courseid);
    tasks.removeWhere((item) => item.courseid == courseid);
    oldlessondata.remove(courseid);
  }

  void _onSchoolClassAdded(String classid) {
    List<StreamSubscription> mClassListeners = [];
    mClassListeners.add(
        dataManager.getSchoolClassInfo(classid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        schoolClassInfos.updateData(
          SchoolClass.fromData(snapshot.data()!),
          ChangeType.MODIFIED,
        );
      } else {
        schoolClassInfos.removeWhere((item) => item.id == snapshot.id);
      }
    }));
    mClassListeners.add(dataManager
        .getTaskRefClass(classid)
        .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        tasks.updateData(SchoolTask.fromData(change.doc.data()!),
            fromDocumentChange(change.type));
      });
    }));
    mClassListeners.add(dataManager
        .getLetterRefClass(classid)
        .where('deleted', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        letters.updateData(Letter.FromData(change.doc.data()),
            fromDocumentChange(change.type));
      });
    }));
    _classlistener[classid] = mClassListeners;
  }

  void _onSchoolClassRemoved(String classid) {
    _classlistener[classid]?.forEach((it) => it.cancel());
    schoolClassInfos.removeWhere((it) => it.id == classid);
    tasks.removeWhere((item) => item.classid == classid);
  }

  Course? getCourseInfo(String courseid) {
    return courseinfo.data[courseid];
  }

  SchoolClass? getClassInfo(String id) {
    return schoolClassInfos.data[id];
  }

  List<Course> getCourseList() {
    return courseinfo.data.values.toList()
      ..sort((c1, c2) => c1.getName().compareTo(c2.getName()));
  }

  Map<String, Lesson> getLessons() {
    Map<String, Lesson> oldlessons = buildSingleMap(oldlessondata);
    Map<String, Lesson> courselessons = buildSingleMapFromList(
        courseinfo.data.values.map((it) => it.lessons).toList());
    courselessons.forEach((key, value) => oldlessons[key] = value);
    return oldlessons;
  }

  Stream<Map<String, Lesson>> getLessonsStream() {
    return courseinfo.stream.map((it) {
      final initialdata =
          it.values.map<Map<String, Lesson>>((it) => it.lessons).toList();
      final newdata = <String, Lesson>{};
      for (final entry in initialdata) {
        newdata.addAll(entry.map((key, value) => MapEntry(key, value)));
      }
      return newdata;
    }).map((datamap) {
      final oldlessons = buildSingleMap<Lesson>(oldlessondata);
      datamap.forEach((key, value) => oldlessons[key] = value);

      return oldlessons;
    });
  }

  Stream<Lesson?> getLessonStream(String lessonid) {
    return getLessonsStream().map((datamap) => datamap[lessonid]);
  }
}
