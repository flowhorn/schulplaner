import 'package:authentification/authentification_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference getUserRef(String uid) =>
    FirebaseFirestore.instance.collection('users').doc(uid);

CollectionReference getUserDataRef(String uid) =>
    getUserRef(uid).collection('data');

DocumentReference getPlannerOrderRef(UserId userId) =>
    getUserDataRef(userId.uid).doc('plannerorder');

CollectionReference getPlannerRef(UserId userId) =>
    getUserRef(userId.uid).collection('planner');
