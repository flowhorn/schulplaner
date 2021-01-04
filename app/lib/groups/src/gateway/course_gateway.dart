import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Helper/LogAnalytics.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class CourseGateway {
  final FirebaseFirestore _firestore;
  final MemberId memberId;
  CourseGateway(this._firestore, this.memberId);

  DocumentReference courseDocumentReference(String courseId) =>
      _firestore.collection('courses').doc(courseId);

  DocumentReference get userRootReference =>
      _firestore.collection('users').doc(memberId.userId.uid);

  DocumentReference get plannerRootReference =>
      userRootReference.collection('planner').doc(memberId.plannerId);

  DocumentReference get plannerConnectionsReference =>
      plannerRootReference.collection('data').doc('connections');

  DocumentReference schoolClassInfoReference(String classid) =>
      _firestore.collection('schoolclasses').doc(classid);

  void CreateCourseAsCreator(Course courseInfo) {
    courseDocumentReference(courseInfo.id).set(courseInfo.copyWith(
      membersData: {
        memberId.toDataString(): MemberData.create(
          id: memberId.toDataString(),
          role: MemberRole.owner,
        )
      },
      membersList: [memberId.toDataString()],
      userRoles: {
        memberId.userId.uid: MemberRole.owner,
      },
    ).toJson());
    plannerConnectionsReference.set(
      {
        'mycourses': {courseInfo.id: true}
      },
      SetOptions(
        merge: true,
      ),
    );
    LogAnalytics.CourseCreated();
  }
}
