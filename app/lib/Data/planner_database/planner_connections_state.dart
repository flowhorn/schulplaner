import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/models/school_class.dart';

import 'class_settings.dart';
import 'indirect_connection.dart';
import 'planner_connections.dart';

class PlannerConnectionsState {
  DataDocumentPackage<PlannerConnections> connections;

  final Map<String, bool> activecourselistener = {};
  final Map<String, bool> activeclasslistener = {};
  Map<String, bool> directconnections = {};
  Map<String, bool> classconnections = {};
  Map<String, ClassSettings> classsettings = {};
  final Map<String, IndirectConnection> indirectconnections = {};
  final Map<String, StreamSubscription> mapofclasslisteners = {};
  VoidData<String> addToDB;
  VoidData<String> removeToDB;
  VoidData<String> addClassToDB, removeClassToDB;

  PlannerConnectionsState({
    required this.connections,
    required this.addToDB,
    required this.removeToDB,
    required this.addClassToDB,
    required this.removeClassToDB,
  }) {
    indirectconnections;
    connections.stream.listen(
      (newdata) {
        if (newdata != null) {
          directconnections = newdata.mycourses;
          classconnections = newdata.myclasses;
          classsettings = newdata.myclasssettings;
          checkConnections_course();
          checkConnections_class();
        }
      },
    );
  }

  void checkConnections_course() {
    for (MapEntry<String, bool> entry
        in activecourselistener.entries.toList()) {
      String courseid = entry.key;
      if (directconnections.containsKey(courseid)) {
        // NOTHING THERE TO DO, ALREADY LISTENING
      } else {
        if (indirectconnections.values
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
    for (MapEntry<String, bool> entry in activeclasslistener.entries.toList()) {
      String classid = entry.key;
      if (classconnections.containsKey(classid)) {
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
    mapofclasslisteners[classid] = FirebaseFirestore.instance
        .collection('schoolclasses')
        .doc(classid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() == null) return;
      SchoolClass schoolClassInfo = SchoolClass.fromData(snapshot.data()!);
      indirectconnections.removeWhere((key, value) {
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
    mapofclasslisteners[classid]?.cancel();
    indirectconnections.removeWhere((key, value) => value.classid == classid);
    checkConnections_course();
    removeClassToDB(classid);
  }

  bool isCourseActivatedInClass(String courseid, String classid) {
    if (classsettings[classid] == null) {
      return true;
    } else {
      ClassSettings classSettings = classsettings[classid]!;
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
