import 'package:authentification/authentification_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference<Map<String, dynamic>> getUserRef(String uid) =>
    FirebaseFirestore.instance.collection('users').doc(uid);

CollectionReference<Map<String, dynamic>> getUserDataRef(String uid) =>
    getUserRef(uid).collection('data');

DocumentReference<Map<String, dynamic>> getPlannerOrderRef(UserId userId) =>
    getUserDataRef(userId.uid).doc('plannerorder');

CollectionReference<Map<String, dynamic>> getPlannerRef(UserId userId) =>
    getUserRef(userId.uid).collection('planner');
