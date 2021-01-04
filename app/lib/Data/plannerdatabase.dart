import 'dart:async';

import 'package:authentification/authentification_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/Data/Planner/AbsentTime.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Data/Planner/Notes.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/LogAnalytics.dart';
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
import 'package:schulplaner8/models/shared_settings.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class IndirectConnection {
  String classid, courseid;
  bool enabled;
  IndirectConnection({this.classid, this.courseid, this.enabled = true});

  String getKey() => classid + '--' + courseid;
}

class ClassSettings {
  String classid;
  Map<String, bool> disabledcourses;

  ClassSettings({this.classid, this.disabledcourses = const {}});

  ClassSettings.fromData(dynamic data, String classid) {
    if (data != null) {
      classid = data['classid'];
      Map<String, dynamic> premap_disabledcourses =
          data['disabledcourses']?.cast<String, dynamic>() ?? {};
      premap_disabledcourses.removeWhere((key, value) => value == null);
      disabledcourses = premap_disabledcourses
          .map<String, bool>((String key, value) => MapEntry(key, true));
    } else {
      classid = classid;
      disabledcourses = {};
    }
  }
}

class PlannerConnectionsState {
  DataDocumentPackage<PlannerConnections> connections;

  Map<String, bool> activecourselistener;
  Map<String, bool> activeclasslistener;
  Map<String, bool> directconnections;
  Map<String, bool> classconnections;
  Map<String, ClassSettings> classsettings;
  Map<String, IndirectConnection> indirectconnections;
  Map<String, StreamSubscription> mapofclasslisteners;
  VoidData<String> addToDB;
  VoidData<String> removeToDB;
  VoidData<String> addClassToDB, removeClassToDB;

  PlannerConnectionsState(this.connections, this.addToDB, this.removeToDB,
      this.addClassToDB, this.removeClassToDB) {
    activecourselistener = {};
    activeclasslistener = {};
    indirectconnections = {};
    mapofclasslisteners = {};
    connections.stream.listen((newdata) {
      if (newdata != null) {
        directconnections = newdata.mycourses;
        classconnections = newdata.myclasses;
        classsettings = newdata.myclasssettings;
        checkConnections_course();
        checkConnections_class();
      }
    });
  }

  void checkConnections_course() {
    for (MapEntry<String, bool> entry
        in activecourselistener.entries.toList()) {
      String courseid = entry.key;
      if ((directconnections ?? {}).containsKey(courseid)) {
        // NOTHING THERE TO DO, ALREADY LISTENING
      } else {
        if ((indirectconnections ?? {})
            .values
            .where((value) {
              if (value.courseid == courseid) {
                return isCourseActivatedInClass(courseid, value.classid);
              } else {
                return false;
              }
            })
            .toList()
            .isNotEmpty) {
          //COURSE IS IN AT LEAST ONE CLASS!
          // NOTHING THERE TO DO, ALREADY LISTENING
        } else {
          //COURSE IN NOT IN ANY CLASS AND NOT FROM USER => LISTENER WILL BE REMOVED!
          _removeCourseToDB(courseid);
        }
      }
    }
    for (String courseid in directconnections.keys) {
      if (activecourselistener.containsKey(courseid)) {
        //ALREADY A CONNECTION, NOTHING THERE TO DO!
      } else {
        //ADD LISTENER
        _addCourseToDB(courseid);
      }
    }
    for (IndirectConnection indirectconnection in indirectconnections.values) {
      if (activecourselistener.containsKey(indirectconnection.courseid)) {
        //ALREADY A CONNECTION, NOTHING THERE TO DO!
      } else {
        //ADD LISTENER
        if (isCourseActivatedInClass(
            indirectconnection.courseid, indirectconnection.classid)) {
          _addCourseToDB(indirectconnection.courseid);
        }
      }
    }
  }

  void checkConnections_class() {
    print('CHECKING CLASS!!');
    for (MapEntry<String, bool> entry in activeclasslistener.entries.toList()) {
      String classid = entry.key;
      if ((classconnections ?? {}).containsKey(classid)) {
        // NOTHING THERE TO DO, ALREADY LISTENING
      } else {
        _removeClassToDB(classid);
      }
    }
    for (String classid in classconnections.keys) {
      if (activeclasslistener.containsKey(classid)) {
        //ALREADY A CONNECTION, NOTHING THERE TO DO!
      } else {
        //ADD LISTENER
        _addClassToDB(classid);
      }
    }
  }

  void _addCourseToDB(String courseid) {
    activecourselistener[courseid] = true;
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      addToDB(courseid);
    });
  }

  void _removeCourseToDB(String courseid) {
    activecourselistener.remove(courseid);
    removeToDB(courseid);
  }

  void _addClassToDB(String classid) {
    activeclasslistener[classid] = true;
    print('ADD CLASS');
    mapofclasslisteners[classid] = FirebaseFirestore.instance
        .collection('schoolclasses')
        .doc(classid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data == null) return;
      SchoolClass schoolClassInfo = SchoolClass.fromData(snapshot.data());
      indirectconnections?.removeWhere((key, value) {
        if (value.classid == classid) {
          if (schoolClassInfo.courses.containsKey(value.courseid)) {
            return false;
          } else {
            return true;
          }
        } else {
          return false;
        }
      });
      schoolClassInfo.courses.forEach((key, value) {
        print('ADDCLASS:' + key);
        indirectconnections[classid + '--' + key] =
            IndirectConnection(classid: classid, courseid: key, enabled: true);
      });
      checkConnections_course();
    });
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      addClassToDB(classid);
    });
  }

  void _removeClassToDB(String classid) {
    activeclasslistener.remove(classid);
    print('REMOVE CLASS');
    mapofclasslisteners[classid]?.cancel();
    indirectconnections?.removeWhere((key, value) => value.classid == classid);
    checkConnections_course();
    removeClassToDB(classid);
  }

  bool isCourseActivatedInClass(String courseid, String classid) {
    if (classsettings[classid] == null) {
      return true;
    } else {
      ClassSettings classSettings = classsettings[classid];
      if (classSettings.disabledcourses.containsKey(courseid)) {
        return false;
      } else {
        return true;
      }
    }
  }

  List<String> getConnectedSchoolClassesFor(String courseid) {
    return indirectconnections.values
        .where((indirect) {
          return indirect.courseid == courseid;
        })
        .map((connection) => connection.classid)
        .toList();
  }
}

class PlannerDatabase {
  final String uid;
  final String plannerid;

  bool isDestroyed = false;
  DocumentReference _rootplanner;
  FirebaseFirestore root;

  DataDocumentPackage<PlannerSettingsData> settings;
  DataDocumentPackage<PlannerConnections> connections;
  DataCollectionPackage<Teacher> teachers;
  DataCollectionPackage<Place> places;
  DataCollectionPackage<CloudFile> personalfiles;
  DataCollectionPackage<NoteData> notes;
  DataCollectionPackage<AbsentTime> absentTime;
  DataCollectionPackage<Grade> grades;
  DataCollectionPackage<SchoolReport> schoolreports;
  DataCombinedPackageSpecial<Course, CoursePersonal> courseinfo;
  DataCombinedPackage<LessonInfo> lessoninfos;
  DataCombinedPackage<SchoolTask> tasks;
  DataCombinedPackage<Letter> letters;
  DataCombinedPackage<SchoolEvent> events;
  DataCombinedPackage<SchoolClass> schoolClassInfos;
  DataCombinedPackage<Holiday> vacations;
  PlannerConnectionsState connectionsState;
  GradeSpanPackage gradespanpackage;
  HolidayGateway holidayGateway;

  Map<String, Map<String, Lesson>> oldlessondata = {};

  Map<String, List<StreamSubscription>> _courselistener;
  Map<String, List<StreamSubscription>> _classlistener;

  final List<StreamSubscription> _otherlistener = [];
  String _loadedvacationpackageid;

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
    @required this.uid,
    @required this.plannerid,
    @required AppSettingsBloc appSettingsBloc,
  }) {
    _courselistener = {};
    _classlistener = {};
    root = FirebaseFirestore.instance;
    dataManager = DataManager(plannerid: plannerid, uid: uid);
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
    _rootplanner
        .collection('data')
        .doc('coursepersonal')
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        data.forEach((key, value) {
          CoursePersonal coursePersonal =
              CoursePersonal.fromData(value?.cast<String, dynamic>());
          courseinfo.updateDataSecondary(coursePersonal, ChangeType.MODIFIED);
        });
      }
    });
    tasks = DataCombinedPackage(getKey: (it) => it.taskid);
    letters = DataCombinedPackage(getKey: (it) => it.id);
    events = DataCombinedPackage(getKey: (it) => it.eventid);
    lessoninfos = DataCombinedPackage(getKey: (it) => it.id);
    schoolClassInfos = DataCombinedPackage(getKey: (it) => it.id);
    connections = DataDocumentPackage(
        reference: dataManager.plannerConnections,
        objectBuilder: (key, value) => PlannerConnections.fromData(value),
        directlyLoad: true,
        loadNullData: true);
    connectionsState = PlannerConnectionsState(connections, _onCourseAdded,
        _onCourseRemoved, _onSchoolClassAdded, _onSchoolClassRemoved);
    teachers = DataCollectionPackage(
        reference: dataManager.teachersRef,
        objectBuilder: (key, it) => Teacher.fromData(it),
        getKey: (it) => it.teacherid,
        sorter: (item1, item2) {
          return (item1.name ?? '').compareTo(item2.name ?? '');
        });
    places = DataCollectionPackage(
        reference: dataManager.placesRef,
        objectBuilder: (key, it) => Place.fromData(it),
        getKey: (it) => it.placeid,
        sorter: (item1, item2) {
          return (item1.name ?? '').compareTo(item2.name ?? '');
        });
    notes = DataCollectionPackage(
      reference: dataManager.notesRef.where('archived', isEqualTo: false),
      objectBuilder: (key, it) => NoteData.fromData(it),
      getKey: (it) => it.noteid,
    );
    personalfiles = DataCollectionPackage(
      reference: dataManager.filesPersonalRef,
      objectBuilder: (key, it) => CloudFile.fromData(it),
      getKey: (it) => it.fileid,
      sorter: (i1, i2) => (i1?.name ?? '').compareTo(i2?.name ?? ''),
    );
    grades = DataCollectionPackage(
        reference: dataManager.gradesRef,
        objectBuilder: (key, it) => Grade.fromData(it),
        getKey: (it) => it.id,
        sorter: (item1, item2) {
          return (item1.date ?? '').compareTo(item2.date ?? '');
        });
    absentTime = DataCollectionPackage(
      reference: dataManager.absentTimeRef,
      objectBuilder: (key, it) => AbsentTime.fromData(it),
      getKey: (it) => it.id,
    );
    schoolreports = DataCollectionPackage(
      reference: dataManager.schoolReportsRef,
      objectBuilder: (key, it) => SchoolReport.fromData(it),
      getKey: (it) => it.id,
    );
    holidayGateway = HolidayGateway(root, HolidayCacheManager());
    vacations = DataCombinedPackage(getKey: (it) => it.id.key);
    _otherlistener.add(dataManager
        .getTaskRefPrivate()
        .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        tasks.updateData(SchoolTask.fromData(change.doc.data()),
            fromDocumentChange(change.type));
      });
    }));
    _otherlistener.add(dataManager
        .getEventRefPrivate()
        .where('date', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        events.updateData(SchoolEvent.fromData(change.doc.data()),
            fromDocumentChange(change.type));
      });
    }));
    _otherlistener.add(settings.stream.listen((plannersettingsdata) {
      String newvacationpackageid = plannersettingsdata?.vacationpackageid;
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
    String regionID = settings.data.vacationpackageid;
    if (regionID == null) return;
    List<Holiday> holidays =
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

  DataManager dataManager;
  DocumentReference getRootReference() => _rootplanner;

  String getMemberId() => dataManager.getMemberId();

  MemberId getMemberIdObject() => dataManager.getMemberIdObject();

  PlannerSettingsData getSettings() =>
      settings.data ?? PlannerSettingsData.fromData(null);

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
            snapshot.exists ? Course.fromData(snapshot.data()) : null,
            ChangeType.MODIFIED);
      }
    }));
    mCourseListeners.add(dataManager
        .getTaskRefCourse(courseid)
        .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        tasks.updateData(SchoolTask.fromData(change.doc.data()),
            fromDocumentChange(change.type));
      });
    }));
    mCourseListeners.add(
        dataManager.getLessonRefCourse(courseid).snapshots().listen((snapshot) {
      oldlessondata[courseid] = snapshot.docs
          .map((snap) => Lesson.fromData(id: snap.id, data: snap.data()))
          .toList()
          .asMap()
          .map(((_, value) => MapEntry(value.lessonid, value)));
      courseinfo.notifyDataSetChanged();
    }));
    mCourseListeners.add(dataManager
        .getEventRefCourse(courseid)
        .where('date', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        events.updateData(SchoolEvent.fromData(change.doc.data()),
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
          LessonInfo.fromData(change.doc.data()),
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
    _courselistener[courseid].forEach((it) => it.cancel());
    _courselistener.remove(courseid);
    courseinfo.removeWhere((info) => info.id == courseid);
    tasks.removeWhere((item) => item.courseid == courseid);
    oldlessondata.remove(courseid);
  }

  void _onSchoolClassAdded(String classid) {
    List<StreamSubscription> mClassListeners = [];
    mClassListeners.add(
        dataManager.getSchoolClassInfo(classid).snapshots().listen((snapshot) {
      schoolClassInfos.updateData(
          snapshot.exists ? SchoolClass.fromData(snapshot.data()) : null,
          ChangeType.MODIFIED);
    }));
    mClassListeners.add(dataManager
        .getTaskRefClass(classid)
        .where('due', isGreaterThanOrEqualTo: getDateTwoWeeksAgo())
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        tasks.updateData(SchoolTask.fromData(change.doc.data()),
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
    _classlistener[classid].forEach((it) => it.cancel());
    schoolClassInfos.removeWhere((it) => it.id == classid);
    tasks.removeWhere((item) => item.classid == classid);
  }

  Course getCourseInfo(String courseid) {
    return courseinfo.data[courseid];
  }

  SchoolClass getClassInfo(String id) {
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
    oldlessons.removeWhere((key, value) => value == null);
    return oldlessons;
  }

  Stream<Map<String, Lesson>> getLessonsStream() {
    return courseinfo.stream.map((it) {
      final initialdata =
          it.values.map<Map<String, Lesson>>((it) => it.lessons).toList();
      final newdata = <String, Lesson>{};
      for (final entry in initialdata) {
        newdata.addAll((entry ?? {}).map((key, value) => MapEntry(key, value)));
      }
      return newdata;
    }).map((datamap) {
      final oldlessons = buildSingleMap<Lesson>(oldlessondata);
      datamap.forEach((key, value) => oldlessons[key] = value);
      oldlessons.removeWhere((key, value) => value == null);
      return oldlessons;
    });
  }

  Stream<Lesson> getLessonStream(String lessonid) {
    return getLessonsStream().map((datamap) => datamap[lessonid]);
  }
}

Map<String, T> buildSingleMap<T>(Map<String, Map<String, T>> initalData) {
  final newdata = <String, T>{};
  for (final entry in initalData.values) {
    newdata.addAll((entry ?? []));
  }
  return newdata;
}

Map<String, T> buildSingleMapFromList<T>(List<Map<String, T>> initalData) {
  Map<String, T> newdata = {};
  for (Map<String, T> entry in initalData) {
    newdata.addAll((entry ?? {}));
  }
  return newdata;
}

class DataManager {
  String plannerid, uid;

  FirebaseFirestore get instance => FirebaseFirestore.instance;
  DocumentReference get userRoot => instance.collection('users').doc(uid);

  DocumentReference userOtherRoot(String userID) =>
      instance.collection('users').doc(userID);
  DocumentReference get plannerRoot =>
      userRoot.collection('planner').doc(plannerid);
  DocumentReference get settingsReference =>
      plannerRoot.collection('data').doc('settings');
  DocumentReference courseRoot(String courseid) =>
      instance.collection('courses').doc(courseid);
  DocumentReference schoolClassRoot(String classid) =>
      instance.collection('schoolclasses').doc(classid);
  DocumentReference get notificationSettings =>
      instance.collection('notifications').doc(getMemberId());

  DataManager({@required this.plannerid, @required this.uid});

  String generateCourseId() => instance.collection('courses').doc().id;
  String generateFileId() => filesPersonalRef.doc().id;
  String generateSchoolClassId() =>
      instance.collection('schoolclasses').doc().id;
  String generateTeacherId() => teachersRef.doc().id;
  String generatePlaceId() => placesRef.doc().id;
  String generateVacationId() => vacationsRef.doc().id;

  static CollectionReference get publiccodeRef {
    return FirebaseFirestore.instance.collection('publiccodes');
  }

  CollectionReference get filesPersonalRef => userRoot.collection('files');

  CollectionReference get teachersRef => plannerRoot.collection('teachers');
  CollectionReference get placesRef => plannerRoot.collection('places');
  CollectionReference get notesRef => plannerRoot.collection('notes');
  CollectionReference get gradesRef => plannerRoot.collection('grades');
  CollectionReference get absentTimeRef =>
      plannerRoot.collection('absenttimes');
  CollectionReference get schoolReportsRef =>
      plannerRoot.collection('schoolreports');
  CollectionReference get vacationsRef => plannerRoot.collection('vacations');
  CollectionReference get vacationpackagesRef =>
      instance.collection('vacationpackages');
  DocumentReference get coursePersonalRef =>
      plannerRoot.collection('data').doc('coursepersonal');
  DocumentReference get plannerConnections =>
      plannerRoot.collection('data').doc('connections');

  DocumentReference getMemberInfo(String memberid) =>
      instance.collection('users').doc(memberid).collection('data').doc('info');
  DocumentReference getCourseInfo(String courseid) => courseRoot(courseid);

  CollectionReference getTaskRefPrivate() => plannerRoot.collection('tasks');
  CollectionReference getTaskRefCourse(String courseid) =>
      courseRoot(courseid).collection('tasks');
  CollectionReference getLessonRefCourse(String courseid) =>
      courseRoot(courseid).collection('lessons');
  CollectionReference getTaskRefClass(String classid) =>
      schoolClassRoot(classid).collection('tasks');

  CollectionReference getLetterRefCourse(String courseid) =>
      courseRoot(courseid).collection('letter');
  CollectionReference getLetterRefClass(String classid) =>
      schoolClassRoot(classid).collection('letter');

  DocumentReference getLetterRef(Letter letter) {
    if (letter.savedin == null) return null;
    if (letter.savedin.type == SavedInType.COURSE) {
      return getLetterRefCourse(letter.savedin.id).doc(letter.id);
    }
    if (letter.savedin.type == SavedInType.CLASS) {
      return getLetterRefClass(letter.savedin.id).doc(letter.id);
    }
    return null;
  }

  //EVENTS
  CollectionReference getEventRefPrivate() => plannerRoot.collection('events');
  CollectionReference getEventRefCourse(String courseid) =>
      courseRoot(courseid).collection('events');
  CollectionReference getEventRefClass(String courseid) =>
      schoolClassRoot(courseid).collection('events');

  CollectionReference getLessonInfoRefCourse(String courseid) =>
      courseRoot(courseid).collection('lessoninfos');

  DocumentReference getSchoolClassInfo(String classid) =>
      schoolClassRoot(classid);

  String getMemberId() => uid + '::' + plannerid;

  MemberId getMemberIdObject() =>
      MemberId(userId: UserId(uid), plannerId: plannerid);

  Reference getFileStorageRef(String fileid, SavedIn savedin) {
    if (savedin.type == SavedInType.PERSONAL) {
      return FirebaseStorage.instance
          .ref()
          .child('files')
          .child('personal')
          .child(savedin.id)
          .child(fileid);
    }
    return null;
  }

  void UpdateSettings(PlannerSettingsData newdata) {
    settingsReference.set(newdata.toJson(), SetOptions(merge: true));
  }

  void AddTeacher(Teacher item) {
    teachersRef.doc(item.teacherid).set(item.toJson());
  }

  void ModifyTeacher(Teacher item) {
    teachersRef.doc(item.teacherid).set(item.toJson());
  }

  void DeleteTeacher(Teacher item) {
    teachersRef.doc(item.teacherid).delete();
  }

  void AddPlace(Place item) {
    placesRef.doc(item.placeid).set(item.toJson());
  }

  void ModifyPlace(Place item) {
    placesRef.doc(item.placeid).set(item.toJson());
  }

  void DeletePlace(Place item) {
    placesRef.doc(item.placeid).delete();
  }

  void AddHoliday(Holiday item) {
    vacationsRef.doc(item.id.key).set(HolidayConverter.toJson(item));
  }

  void ModifyVacation(Holiday item) {
    vacationsRef.doc(item.id.key).set(HolidayConverter.toJson(item));
  }

  void DeleteVacation(Holiday item) {
    vacationsRef.doc(item.id.key).delete();
  }

  void ModifyCoursePersonal(CoursePersonal coursePersonal) {
    coursePersonalRef.set(
      {coursePersonal.courseid: coursePersonal.toJson()},
      SetOptions(
        merge: true,
      ),
    );
  }

  void ModifyCourse(Course courseInfo) {
    getCourseInfo(courseInfo.id).set(
      courseInfo.toJson_OnlyInfo(),
      SetOptions(
        merge: true,
      ),
    );
    LogAnalytics.CourseChanged();
  }

  void CreateLetter(Letter letter) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(letter
          .copyWith(
            lastchanged: Timestamp.now(),
            published: Timestamp.now(),
          )
          .toJson());
    }
    LogAnalytics.LetterCreated();
  }

  void ModifyLetter(Letter letter) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(
        letter.copyWith(lastchanged: Timestamp.now()).toJson(),
        SetOptions(
          merge: true,
        ),
      );
    }
    LogAnalytics.LetterChanged();
  }

  void SetResponseLetter(Letter letter, LetterResponse response) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(
        {
          'responses': {response.id: response.toJson()}
        },
        SetOptions(
          merge: true,
        ),
      );
    }
    LogAnalytics.LetterResponse();
  }

  void ResetResponseLetter(Letter letter) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(
        {'responses': null},
        SetOptions(
          merge: true,
        ),
      );
    }
    LogAnalytics.LetterResponse();
  }

  void ArchiveLetter(Letter letter, bool archived) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(
        {'archived': archived},
        SetOptions(
          merge: true,
        ),
      );
    }
    LogAnalytics.LetterArchived(archived);
  }

  void DeleteLetter(Letter letter, bool deleted) {
    var ref = getLetterRef(letter);
    if (ref != null) {
      ref.set(
        {'deleted': deleted},
        SetOptions(
          merge: true,
        ),
      );
    }
    LogAnalytics.LetterRemoved();
  }

  void CreateSchoolTask(SchoolTask schoolTask) {
    schoolTask.creatorid = getMemberId();
    if (schoolTask.private) {
      String newTaskid = getTaskRefPrivate().doc().id;
      schoolTask.taskid = newTaskid;
      getTaskRefPrivate().doc(schoolTask.taskid).set(
            schoolTask.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolTask.courseid != null) {
        String newTaskid = getTaskRefCourse(schoolTask.courseid).doc().id;
        schoolTask.taskid = newTaskid;
        getTaskRefCourse(schoolTask.courseid).doc(schoolTask.taskid).set(
              schoolTask.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          String newTaskid = getTaskRefClass(schoolTask.classid).doc().id;
          schoolTask.taskid = newTaskid;
          getTaskRefClass(schoolTask.classid).doc(schoolTask.taskid).set(
                schoolTask.toJson(),
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
    LogAnalytics.TaskCreated();
  }

  void ModifySchoolTask(SchoolTask schoolTask) {
    if (schoolTask.private) {
      getTaskRefPrivate().doc(schoolTask.taskid).set(
            schoolTask.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolTask.courseid != null) {
        getTaskRefCourse(schoolTask.courseid).doc(schoolTask.taskid).set(
              schoolTask.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid).doc(schoolTask.taskid).set(
                schoolTask.toJson(),
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
    LogAnalytics.TaskChanged();
  }

  void ActivateCourseFromClassForUser(
      String classid, String courseid, bool activate) {
    plannerConnections.set(
      {
        'myclasssettings': {
          classid: {
            'disabledcourses': {courseid: activate ? null : true}
          }
        }
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  void ModifySchoolEvent(SchoolEvent schoolEvent) {
    if (schoolEvent.private) {
      getEventRefPrivate().doc(schoolEvent.eventid).set(
            schoolEvent.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolEvent.courseid != null) {
        getEventRefCourse(schoolEvent.courseid).doc(schoolEvent.eventid).set(
              schoolEvent.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid).doc(schoolEvent.eventid).set(
                schoolEvent.toJson(),
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void CreateSchoolEvent(SchoolEvent schoolEvent) {
    schoolEvent.creatorid = getMemberId();
    if (schoolEvent.private) {
      String neweventid = getEventRefPrivate().doc().id;
      schoolEvent.eventid = neweventid;
      getEventRefPrivate().doc(schoolEvent.eventid).set(
            schoolEvent.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolEvent.courseid != null) {
        String neweventid = getEventRefCourse(schoolEvent.courseid).doc().id;
        schoolEvent.eventid = neweventid;
        getEventRefCourse(schoolEvent.courseid).doc(schoolEvent.eventid).set(
              schoolEvent.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          String neweventid = getEventRefClass(schoolEvent.classid).doc().id;
          schoolEvent.eventid = neweventid;
          getEventRefClass(schoolEvent.classid).doc(schoolEvent.eventid).set(
                schoolEvent.toJson(),
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void ModifyLesson(Lesson lesson) {
    if (lesson.courseid != null) {
      getCourseInfo(lesson.courseid).set(
        {
          'lessons': {lesson.lessonid: lesson.toJson()},
        },
        SetOptions(
          merge: true,
        ),
      );
      try {
        getLessonRefCourse(lesson.courseid).doc(lesson.lessonid).delete();
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void DeleteLesson(Lesson lesson) {
    if (lesson.courseid != null) {
      getCourseInfo(lesson.courseid).set(
        {
          'lessons': {lesson.lessonid: FieldValue.delete()},
        },
        SetOptions(
          merge: true,
        ),
      );
      try {
        getLessonRefCourse(lesson.courseid).doc(lesson.lessonid).delete();
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void CreateLesson(Lesson lesson) {
    if (lesson.courseid != null) {
      String newlessonid = getLessonRefCourse(lesson.courseid).doc().id;
      lesson.lessonid = newlessonid;
      getCourseInfo(lesson.courseid).set(
        {
          'lessons': {lesson.lessonid: lesson.toJson()},
        },
        SetOptions(
          merge: true,
        ),
      );
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void ModifyLessonInfo(LessonInfo lessoninfo) {
    if (lessoninfo.courseid != null) {
      getLessonInfoRefCourse(lessoninfo.courseid).doc(lessoninfo.id).set(
            lessoninfo.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void DeleteLessonInfo(LessonInfo lessoninfo) {
    if (lessoninfo.courseid != null) {
      getLessonInfoRefCourse(lessoninfo.courseid).doc(lessoninfo.id).delete();
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void CreateLessonInfo(LessonInfo lessoninfo) {
    if (lessoninfo.courseid != null) {
      String newlessoninfoid =
          getLessonInfoRefCourse(lessoninfo.courseid).doc().id;
      lessoninfo.id = newlessoninfoid;
      getLessonInfoRefCourse(lessoninfo.courseid).doc(lessoninfo.id).set(
            lessoninfo.toJson(),
            SetOptions(
              merge: true,
            ),
          );
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void SetFinishedSchoolTask(SchoolTask schoolTask, bool finished) {
    Map<String, dynamic> finishedmap = {
      'finished': {
        getMemberId(): TaskFinished(
                timestamp: Timestamp.fromDate(DateTime.now()),
                finished: finished)
            .toJson()
      }
    };
    if (schoolTask.private) {
      getTaskRefPrivate().doc(schoolTask.taskid).set(
            finishedmap,
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolTask.courseid != null) {
        getTaskRefCourse(schoolTask.courseid).doc(schoolTask.taskid).set(
              finishedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid).doc(schoolTask.taskid).set(
                finishedmap,
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void SetArchivedSchoolTask(SchoolTask schoolTask, bool archived) {
    Map<String, dynamic> archivedmap = {'archived': archived};
    if (schoolTask.private) {
      getTaskRefPrivate().doc(schoolTask.taskid).set(
            archivedmap,
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolTask.courseid != null) {
        getTaskRefCourse(schoolTask.courseid).doc(schoolTask.taskid).set(
              archivedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid).doc(schoolTask.taskid).set(
                archivedmap,
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void DeleteSchoolTask(SchoolTask schoolTask) {
    if (schoolTask.private) {
      getTaskRefPrivate().doc(schoolTask.taskid).delete();
    } else {
      if (schoolTask.courseid != null) {
        getTaskRefCourse(schoolTask.courseid).doc(schoolTask.taskid).delete();
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid).doc(schoolTask.taskid).delete();
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
    LogAnalytics.TaskRemoved();
  }

  void SetArchivedSchoolEvent(SchoolEvent schoolEvent, bool archived) {
    Map<String, dynamic> archivedmap = {'archived': archived};
    if (schoolEvent.private) {
      getEventRefPrivate().doc(schoolEvent.eventid).set(
            archivedmap,
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolEvent.courseid != null) {
        getEventRefCourse(schoolEvent.courseid).doc(schoolEvent.eventid).set(
              archivedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid).doc(schoolEvent.eventid).set(
                archivedmap,
                SetOptions(
                  merge: true,
                ),
              );
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void DeleteSchoolEvent(SchoolEvent schoolEvent) {
    if (schoolEvent.private) {
      getEventRefPrivate().doc(schoolEvent.eventid).delete();
    } else {
      if (schoolEvent.courseid != null) {
        getEventRefCourse(schoolEvent.courseid)
            .doc(schoolEvent.eventid)
            .delete();
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid)
              .doc(schoolEvent.eventid)
              .delete();
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
  }

  void AddSchoolClass(SchoolClass classInfo) {
    getSchoolClassInfo(classInfo.id).set(classInfo.toJson());
  }

  void ModifySchoolClass(SchoolClass classInfo) {
    getSchoolClassInfo(classInfo.id).set(
      classInfo.toJson_OnlyInfos(),
      SetOptions(
        merge: true,
      ),
    );
  }

  void ConnectCourseToSchoolClassSens(Course courseInfo, String classid) {
    getCourseInfo(courseInfo.id).set(
      {
        'connectedclasses': {classid: true}
      },
      SetOptions(
        merge: true,
      ),
    );
    getSchoolClassInfo(classid).set(
      {
        'courses': {courseInfo.id: true}
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  void UpdateSchoolClassSharedSettings(
      String schoolClassID, SharedSettings sharedSettings) {
    getSchoolClassInfo(schoolClassID).set(
      {
        'sharedSettings': sharedSettings?.toJson(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  void CreateNewFile(CloudFile file) {
    if (file.savedin.type == SavedInType.PERSONAL) {
      filesPersonalRef.doc(file.fileid).set(file.toJson());
    }
  }

  void DeleteFile(CloudFile file) {
    if (file.savedin.type == SavedInType.PERSONAL) {
      print('DELETING FILE');
      filesPersonalRef.doc(file.fileid).delete();
      if (file.fileform == FileForm.STANDARD) {
        getFileStorageRef(file.fileid, file.savedin).delete().then((_) {
          showToastMessage(msg: 'Succesful/Erfolgreich');
        });
      }
    }
  }

  void CreateNote(NoteData noteData) {
    notesRef.doc(noteData.noteid).set(noteData.toJson());
  }

  void ModifyNote(NoteData noteData) {
    notesRef.doc(noteData.noteid).set(
          noteData.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void DeleteNote(NoteData noteData) {
    notesRef.doc(noteData.noteid).delete();
  }

  void SetArchivedNote(NoteData noteData, bool archived) {
    notesRef.doc(noteData.noteid).set(
      {'archived': archived},
      SetOptions(
        merge: true,
      ),
    );
  }

  void CreateAbsentTime(AbsentTime item) {
    absentTimeRef.doc(item.id).set(item.toJson());
  }

  void ModifyAbsentTime(AbsentTime item) {
    absentTimeRef.doc(item.id).set(
          item.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void DeleteAbsentTime(AbsentTime item) {
    absentTimeRef.doc(item.id).delete();
  }

  void CreateSchoolReport(SchoolReport item) {
    schoolReportsRef.doc(item.id).set(item.toJson());
  }

  void ModifySchoolReport(SchoolReport item) {
    schoolReportsRef.doc(item.id).set(
          item.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void DeleteSchoolReport(SchoolReport item) {
    schoolReportsRef.doc(item.id).delete();
  }

  void CreateGrade(Grade item) {
    gradesRef.doc(item.id).set(item.toJson());
  }

  void ModifyGrade(Grade item) {
    gradesRef.doc(item.id).set(
          item.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void DeleteGrade(Grade item) {
    gradesRef.doc(item.id).delete();
  }
}
