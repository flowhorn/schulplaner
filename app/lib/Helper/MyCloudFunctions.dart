import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

Future<Course> getCourseInformation(String courseid) {
  return FirebaseFirestore.instance
      .collection("courses")
      .doc(courseid)
      .get()
      .then((snap) => Course.fromData(snap.data()));
  /*
  return FirebaseFunctions.instance
      .httpsCallable( "getCourseInfo")
      .call({
    'courseid': courseid,
  }).then((result) {
    if (result.data == null) return null;
    var courseinfodata = result.data['courseinfo'];
    var courseinfo = Course.fromData(courseinfodata.cast<String, dynamic>());
    return courseinfo;
  }).catchError((error) {
    print(error);
    return Future.error(error);
  });
  */
}

Future<SchoolClass> getSchoolClassInformation(String classid) {
  return FirebaseFirestore.instance
      .collection("schoolclasses")
      .doc(classid)
      .get()
      .then((snap) => SchoolClass.fromData(snap.data()));
  /*
  return FirebaseFunctions.instance
      .httpsCallable( "getSchoolClassInfo")
      .call({
    'classid': classid,
  }).then((result) {
    if (result.data == null) return null;
    var classinfodata = result.data['classinfo'];
    if (classinfodata == null) {
      print("NODATA`?");
      print(result);
      return null;
    }
    var classinfo =
        SchoolClassInfo.fromData(classinfodata?.cast<String, dynamic>());
    return classinfo;
  }).catchError((error) {
    print(error);
    return Future.error(error);
  });
 */
}

Future<bool> changeMemberTypeUserCourse({
  @required String courseID,
  @required String memberID,
  @required MemberRole newRole,
}) {
  return FirebaseFunctions.instance
      .httpsCallable("CourseUpdateMemberRole")
      .call({
    'courseID': courseID,
    'memberID': memberID,
    'newRole': memberRoleEnumToString(newRole),
    'requestorID': null,
  }).then<bool>((result) {
    if (result.data is bool) {
      return result.data;
    } else {
      return false;
    }
  });
}

Future<bool> addCourseToClass({String courseid, String classid}) {
  return FirebaseFunctions.instance.httpsCallable("schoolClassAddCourse").call({
    'courseid': courseid,
    'classid': classid,
  }).then<bool>((result) {
    print(result.data);
    if (result.data is bool) {
      return result.data;
    } else {
      return false;
    }
  }).catchError((error) {
    print(error);
    return false;
  });
}

Future<bool> changeMemberTypeUserSchoolClass(
    {String classid, String memberid, MemberRole newRole}) {
  print(newRole.toString());
  return FirebaseFunctions.instance
      .httpsCallable("ClassUpdateMemberRole")
      .call({
    'classID': classid,
    'memberID': memberid,
    'newRole': memberRoleEnumToString(newRole),
    'requestorID': null,
  }).then<bool>((result) {
    if (result.data is bool) {
      return result.data;
    } else {
      return false;
    }
  });
}

Future<bool> removeCourseToClass({String courseid, String classid}) {
  return FirebaseFunctions.instance
      .httpsCallable("schoolClassRemoveCourse")
      .call({
    'courseid': courseid,
    'classid': classid,
  }).then<bool>((result) {
    print("REMOVE::");
    print(result.data);
    print(result.data.runtimeType);
    if (result.data is bool) {
      return result.data;
    } else {
      return false;
    }
  }).catchError((error) {
    print(error);
    return false;
  });
}
