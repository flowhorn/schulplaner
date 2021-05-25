import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/models/user.dart';

class UserDatabase {
  final String uid;

  late DocumentReference<Map<String, dynamic>> _root;

  late DataDocumentPackage<UserProfile> userprofile;
  late DataDocumentPackage<User> user;
  UserDatabase({required this.uid}) {
    _root = FirebaseFirestore.instance.collection('users').doc(uid);
    userprofile = DataDocumentPackage(
        reference: _root.collection('data').doc('info'),
        objectBuilder: (key, it) => UserProfile.fromData(it),
        directlyLoad: true);
    user = DataDocumentPackage(
        reference: _root,
        objectBuilder: (key, value) => User.fromData(id: key, data: value),
        directlyLoad: true,
        loadNullData: true);
  }

  DocumentReference getRootReference() => _root;

  void onDestroy() {
    userprofile.close();
  }
}

class User {
  final String id, name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromData({required String id, required dynamic data}) {
    if (data != null) {
      return User(
        id: id,
        name: data['name'] ?? 'Anonym',
      );
    } else {
      return User(
        id: id,
        name: 'Anonym',
      );
    }
  }
}
