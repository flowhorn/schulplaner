import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/models/member.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_models/schulplaner_models.dart';

class SchoolClassGateway {
  final FirebaseFirestore _firestore;
  final MemberId memberId;
  SchoolClassGateway(this._firestore, this.memberId);

  DocumentReference courseDocumentReference(String courseId) =>
      _firestore.collection("courses").doc(courseId);

  DocumentReference get userRootReference =>
      _firestore.collection("users").doc(memberId.userId.uid);

  DocumentReference get plannerRootReference =>
      userRootReference.collection("planner").doc(memberId.plannerId);

  DocumentReference get plannerConnectionsReference =>
      plannerRootReference.collection("data").doc("connections");

  DocumentReference schoolClassInfoReference(String classid) =>
      _firestore.collection("schoolclasses").doc(classid);

  void CreateSchoolClassAsCreator(SchoolClass classInfo) {
    schoolClassInfoReference(classInfo.id).set(
      classInfo.copyWith(
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
      ).toJson(),
      SetOptions(
        merge: true,
      ),
    );
    plannerConnectionsReference.set(
      {
        'myclasses': {classInfo.id: true}
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
