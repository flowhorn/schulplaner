import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'dart:async';

import 'package:schulplaner8/models/coursepermission.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_models/schulplaner_models.dart';
export 'package:schulplaner8/models/coursepermission.dart';

Future<bool> requestPermissionCourse({
  required PlannerDatabase database,
  required PermissionAccessType category,
  required String courseid,
}) {
  if (database.courseinfo.data[courseid]?.membersData != null &&
      !areThereAdmins(database.courseinfo.data[courseid]!.membersData) &&
      !areClassesConnected(
          database.courseinfo.data[courseid]!.connectedclasses)) {
    database.dataManager.courseRoot(courseid).set(
      {
        'membersList': FieldValue.arrayUnion([database.getMemberId()]),
        'membersData': {
          database.getMemberId(): MemberData.create(
                  role: MemberRole.admin, id: database.getMemberId())
              .toJson()
        }
      },
      SetOptions(
        merge: true,
      ),
    );
    return Future.value(true);
  }
  MemberData? courseMember =
      database.courseinfo.data[courseid]!.membersData[database.getMemberId()];
  MemberRole? courseRole = courseMember?.role;
  bool courseResult =
      requestPermission(role: courseRole, permissiontype: category);
  if (courseResult == true) return Future.value(true);

  //CHECK IF CONNECTED WITH CLASSES:
  List<SchoolClass?> classes = database
      .courseinfo.data[courseid]!.connectedclasses.keys
      .map((classid) => database.schoolClassInfos.data.containsKey(classid)
          ? database.schoolClassInfos.data[classid]
          : null)
      .where((it) => it != null)
      .toList();
  if (classes.isNotEmpty) {
    //THERE ARE CONNECTED CLASSES, CHECK FOR EACH CLASS...
    for (SchoolClass? classInfo in classes) {
      MemberData? classMember = classInfo?.membersData[database.getMemberId()];
      MemberRole? classRole = classMember?.role;
      bool classResult =
          requestPermission(role: classRole, permissiontype: category);
      if (classResult == true) return Future.value(true);
    }
    return Future.value(false);
  }
  return Future.value(false);
}

bool areThereAdmins(Map<String, MemberData> datamap) {
  Iterable<MemberData> list = datamap.values.where(
      (it) => (it.role == MemberRole.owner || it.role == MemberRole.admin));
  if (list.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

bool areClassesConnected(Map<String, bool>? connectedclasses) {
  Iterable<bool> list =
      (connectedclasses ?? {}).values.where((it) => it == true);
  if (list.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<bool> requestPermissionClass({
  required PlannerDatabase database,
  required PermissionAccessType category,
  required String classid,
}) {
  if (database.schoolClassInfos.data[classid]?.membersData != null &&
      !areThereAdmins(database.schoolClassInfos.data[classid]!.membersData)) {
    database.dataManager.schoolClassRoot(classid).set(
      {
        'membersList': FieldValue.arrayUnion([database.getMemberId()]),
        'membersData': {
          database.getMemberId(): MemberData.create(
                  role: MemberRole.admin, id: database.getMemberId())
              .toJson()
        }
      },
      SetOptions(
        merge: true,
      ),
    );
    return Future.value(true);
  }
  MemberData? classMember = database
      .schoolClassInfos.data[classid]?.membersData[database.getMemberId()];
  MemberRole? classRole = classMember?.role;
  bool classResult =
      requestPermission(role: classRole, permissiontype: category);
  if (classResult == true) return Future.value(true);
  return Future.value(false);
}

Future<bool> requestSimplePermission(
    {required BuildContext context,
    required PlannerDatabase database,
    required PermissionAccessType category,
    required String id,
    int type = 0,
    String? routname}) async {
  switch (type) {
    case 0:
      {
        return await requestPermissionCourse(
                database: database, category: category, courseid: id)
            .then((result) {
          if (result) {
            if (routname != null) popNavigatorBy(context, text: routname);
            return Future.value(true);
          } else {
            var sheet = showPermissionStateSheet(context: context);
            sheet.value = false;
            return Future.value(false);
          }
        });
      }
    case 1:
      {
        return await requestPermissionClass(
                database: database, category: category, classid: id)
            .then((result) {
          if (result) {
            if (routname != null) popNavigatorBy(context, text: routname);
            return Future.value(true);
          } else {
            var sheet = showPermissionStateSheet(context: context);
            sheet.value = false;
            return Future.value(false);
          }
        });
      }
  }
  var sheet = showPermissionStateSheet(context: context);
  sheet.value = false;
  return Future.value(false);
}

Future<bool> requestSavedInSimplePermission({
  required BuildContext context,
  required PlannerDatabase database,
  required PermissionAccessType category,
  required SavedIn savedin,
  String? routname,
}) async {
  switch (savedin.type) {
    case SavedInType.COURSE:
      {
        return await requestPermissionCourse(
                database: database, category: category, courseid: savedin.id)
            .then((result) {
          if (result) {
            if (routname != null) popNavigatorBy(context, text: routname);
            return Future.value(true);
          } else {
            var sheet = showPermissionStateSheet(context: context);
            sheet.value = false;
            return Future.value(false);
          }
        });
      }
    case SavedInType.CLASS:
      {
        return await requestPermissionClass(
                database: database, category: category, classid: savedin.id)
            .then((result) {
          if (result) {
            if (routname != null) popNavigatorBy(context, text: routname);
            return Future.value(true);
          } else {
            var sheet = showPermissionStateSheet(context: context);
            sheet.value = false;
            return Future.value(false);
          }
        });
      }
    case SavedInType.PERSONAL:
      {
        return Future.value(true);
      }
  }
  var sheet = showPermissionStateSheet(context: context);
  sheet.value = false;
  return Future.value(false);
}
