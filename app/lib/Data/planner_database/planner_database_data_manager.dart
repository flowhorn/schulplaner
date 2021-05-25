import 'package:authentification/authentification_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/Data/Planner/AbsentTime.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Data/Planner/Notes.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Helper/LogAnalytics.dart';

import 'package:schulplaner8/OldGrade/SchoolReport.dart';
import 'package:schulplaner8/OldGrade/models/grade.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/groups/src/models/place.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner8/models/shared_settings.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class DataManager {
  final String plannerid, uid;

  FirebaseFirestore get instance => FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> get userRoot =>
      instance.collection('users').doc(uid);

  DocumentReference<Map<String, dynamic>> userOtherRoot(String userID) =>
      instance.collection('users').doc(userID);
  DocumentReference<Map<String, dynamic>> get plannerRoot =>
      userRoot.collection('planner').doc(plannerid);
  DocumentReference<Map<String, dynamic>> get settingsReference =>
      plannerRoot.collection('data').doc('settings');
  DocumentReference<Map<String, dynamic>> courseRoot(String courseid) =>
      instance.collection('courses').doc(courseid);
  DocumentReference<Map<String, dynamic>> schoolClassRoot(String classid) =>
      instance.collection('schoolclasses').doc(classid);
  DocumentReference<Map<String, dynamic>> get notificationSettings =>
      instance.collection('notifications').doc(getMemberId());

  DataManager({
    required this.plannerid,
    required this.uid,
  });

  String generateCourseId() => instance.collection('courses').doc().id;
  String generateFileId() => filesPersonalRef.doc().id;
  String generateSchoolClassId() =>
      instance.collection('schoolclasses').doc().id;
  String generateTeacherId() => teachersRef.doc().id;
  String generatePlaceId() => placesRef.doc().id;
  String generateVacationId() => vacationsRef.doc().id;

  static CollectionReference<Map<String, dynamic>> get publiccodeRef {
    return FirebaseFirestore.instance.collection('publiccodes');
  }

  CollectionReference<Map<String, dynamic>> get filesPersonalRef =>
      userRoot.collection('files');

  CollectionReference<Map<String, dynamic>> get teachersRef =>
      plannerRoot.collection('teachers');
  CollectionReference<Map<String, dynamic>> get placesRef =>
      plannerRoot.collection('places');
  CollectionReference<Map<String, dynamic>> get notesRef =>
      plannerRoot.collection('notes');
  CollectionReference<Map<String, dynamic>> get gradesRef =>
      plannerRoot.collection('grades');
  CollectionReference<Map<String, dynamic>> get absentTimeRef =>
      plannerRoot.collection('absenttimes');
  CollectionReference<Map<String, dynamic>> get schoolReportsRef =>
      plannerRoot.collection('schoolreports');
  CollectionReference<Map<String, dynamic>> get vacationsRef =>
      plannerRoot.collection('vacations');
  CollectionReference<Map<String, dynamic>> get vacationpackagesRef =>
      instance.collection('vacationpackages');
  DocumentReference<Map<String, dynamic>> get coursePersonalRef =>
      plannerRoot.collection('data').doc('coursepersonal');
  DocumentReference<Map<String, dynamic>> get plannerConnections =>
      plannerRoot.collection('data').doc('connections');

  DocumentReference<Map<String, dynamic>> getMemberInfo(String memberid) =>
      instance.collection('users').doc(memberid).collection('data').doc('info');
  DocumentReference<Map<String, dynamic>> getCourseInfo(String courseid) =>
      courseRoot(courseid);

  CollectionReference<Map<String, dynamic>> getTaskRefPrivate() =>
      plannerRoot.collection('tasks');
  CollectionReference<Map<String, dynamic>> getTaskRefCourse(String courseid) =>
      courseRoot(courseid).collection('tasks');
  CollectionReference<Map<String, dynamic>> getLessonRefCourse(
          String courseid) =>
      courseRoot(courseid).collection('lessons');
  CollectionReference<Map<String, dynamic>> getTaskRefClass(String classid) =>
      schoolClassRoot(classid).collection('tasks');

  CollectionReference<Map<String, dynamic>> getLetterRefCourse(
          String courseid) =>
      courseRoot(courseid).collection('letter');
  CollectionReference<Map<String, dynamic>> getLetterRefClass(String classid) =>
      schoolClassRoot(classid).collection('letter');

  DocumentReference<Map<String, dynamic>>? getLetterRef(Letter letter) {
    if (letter.savedin == null) return null;
    if (letter.savedin?.type == SavedInType.COURSE) {
      return getLetterRefCourse(letter.savedin!.id!).doc(letter.id);
    }
    if (letter.savedin?.type == SavedInType.CLASS) {
      return getLetterRefClass(letter.savedin!.id!).doc(letter.id);
    }
    return null;
  }

  //EVENTS
  CollectionReference<Map<String, dynamic>> getEventRefPrivate() =>
      plannerRoot.collection('events');
  CollectionReference<Map<String, dynamic>> getEventRefCourse(
          String courseid) =>
      courseRoot(courseid).collection('events');
  CollectionReference<Map<String, dynamic>> getEventRefClass(String courseid) =>
      schoolClassRoot(courseid).collection('events');

  CollectionReference<Map<String, dynamic>> getLessonInfoRefCourse(
          String courseid) =>
      courseRoot(courseid).collection('lessoninfos');

  DocumentReference<Map<String, dynamic>> getSchoolClassInfo(String classid) =>
      schoolClassRoot(classid);

  String getMemberId() => uid + '::' + plannerid;

  MemberId getMemberIdObject() =>
      MemberId(userId: UserId(uid), plannerId: plannerid);

  Reference? getFileStorageRef(String fileid, SavedIn savedin) {
    if (savedin.type == SavedInType.PERSONAL) {
      return FirebaseStorage.instance
          .ref()
          .child('files')
          .child('personal')
          .child(savedin.id!)
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
        String newTaskid = getTaskRefCourse(schoolTask.courseid!).doc().id;
        schoolTask.taskid = newTaskid;
        getTaskRefCourse(schoolTask.courseid!).doc(schoolTask.taskid).set(
              schoolTask.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          String newTaskid = getTaskRefClass(schoolTask.classid!).doc().id;
          schoolTask.taskid = newTaskid;
          getTaskRefClass(schoolTask.classid!).doc(schoolTask.taskid).set(
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
        getTaskRefCourse(schoolTask.courseid!).doc(schoolTask.taskid).set(
              schoolTask.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid!).doc(schoolTask.taskid).set(
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
        getEventRefCourse(schoolEvent.courseid!).doc(schoolEvent.eventid).set(
              schoolEvent.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid!).doc(schoolEvent.eventid).set(
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
        String neweventid = getEventRefCourse(schoolEvent.courseid!).doc().id;
        schoolEvent.eventid = neweventid;
        getEventRefCourse(schoolEvent.courseid!).doc(schoolEvent.eventid).set(
              schoolEvent.toJson(),
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          String neweventid = getEventRefClass(schoolEvent.classid!).doc().id;
          schoolEvent.eventid = neweventid;
          getEventRefClass(schoolEvent.classid!).doc(schoolEvent.eventid).set(
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
      getCourseInfo(lesson.courseid!).set(
        {
          'lessons': {lesson.lessonid: lesson.toJson()},
        },
        SetOptions(
          merge: true,
        ),
      );
      try {
        getLessonRefCourse(lesson.courseid!).doc(lesson.lessonid).delete();
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void DeleteLesson(Lesson lesson) {
    if (lesson.courseid != null) {
      getCourseInfo(lesson.courseid!).set(
        {
          'lessons': {lesson.lessonid: FieldValue.delete()},
        },
        SetOptions(
          merge: true,
        ),
      );
      try {
        getLessonRefCourse(lesson.courseid!).doc(lesson.lessonid).delete();
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('NO PLACE TO SAVE TASK???');
    }
  }

  void CreateLesson(Lesson lesson) {
    if (lesson.courseid != null) {
      String newlessonid = getLessonRefCourse(lesson.courseid!).doc().id;
      lesson.lessonid = newlessonid;
      getCourseInfo(lesson.courseid!).set(
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
    getLessonInfoRefCourse(lessoninfo.courseid!).doc(lessoninfo.id).set(
          lessoninfo.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void DeleteLessonInfo(LessonInfo lessoninfo) {
    getLessonInfoRefCourse(lessoninfo.courseid!).doc(lessoninfo.id).delete();
  }

  void CreateLessonInfo(LessonInfo lessoninfo) {
    String newlessoninfoid =
        getLessonInfoRefCourse(lessoninfo.courseid!).doc().id;
    lessoninfo.id = newlessoninfoid;
    getLessonInfoRefCourse(lessoninfo.courseid!).doc(lessoninfo.id).set(
          lessoninfo.toJson(),
          SetOptions(
            merge: true,
          ),
        );
  }

  void SetFinishedSchoolTask(SchoolTask schoolTask, bool finished) {
    Map<String, dynamic> finishedmap = {
      'finished': {
        getMemberId(): TaskFinished(
          timestamp: Timestamp.fromDate(DateTime.now()),
          finished: finished,
        ).toJson()
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
        print('Set Task as DOne');
        getTaskRefCourse(schoolTask.courseid!).doc(schoolTask.taskid).set(
              finishedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid!).doc(schoolTask.taskid).set(
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
    final archivedmap = <String, dynamic>{'archived': archived};
    if (schoolTask.private) {
      getTaskRefPrivate().doc(schoolTask.taskid).set(
            archivedmap,
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolTask.courseid != null) {
        getTaskRefCourse(schoolTask.courseid!).doc(schoolTask.taskid).set(
              archivedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid!).doc(schoolTask.taskid).set(
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
        getTaskRefCourse(schoolTask.courseid!).doc(schoolTask.taskid).delete();
      } else {
        if (schoolTask.classid != null) {
          getTaskRefClass(schoolTask.classid!).doc(schoolTask.taskid).delete();
        } else {
          throw Exception('NO PLACE TO SAVE TASK???');
        }
      }
    }
    LogAnalytics.TaskRemoved();
  }

  void SetArchivedSchoolEvent(SchoolEvent schoolEvent, bool archived) {
    final archivedmap = <String, dynamic>{'archived': archived};
    if (schoolEvent.private) {
      getEventRefPrivate().doc(schoolEvent.eventid).set(
            archivedmap,
            SetOptions(
              merge: true,
            ),
          );
    } else {
      if (schoolEvent.courseid != null) {
        getEventRefCourse(schoolEvent.courseid!).doc(schoolEvent.eventid).set(
              archivedmap,
              SetOptions(
                merge: true,
              ),
            );
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid!).doc(schoolEvent.eventid).set(
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
        getEventRefCourse(schoolEvent.courseid!)
            .doc(schoolEvent.eventid)
            .delete();
      } else {
        if (schoolEvent.classid != null) {
          getEventRefClass(schoolEvent.classid!)
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
      String schoolClassID, SharedSettings? sharedSettings) {
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
    if (file.savedin?.type == SavedInType.PERSONAL) {
      filesPersonalRef.doc(file.fileid).set(file.toJson());
    }
  }

  void DeleteFile(CloudFile file) {
    if (file.savedin?.type == SavedInType.PERSONAL) {
      print('DELETING FILE');
      filesPersonalRef.doc(file.fileid).delete();
      if (file.fileform == FileForm.STANDARD) {
        getFileStorageRef(file.fileid!, file.savedin!)?.delete().then((_) {
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
