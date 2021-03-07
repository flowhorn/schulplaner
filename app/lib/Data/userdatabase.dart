//@dart = 2.11
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner8/Helper/database_foundation.dart';
import 'package:schulplaner8/models/user.dart';

class UserDatabase {
  final String uid;

  DocumentReference _root;

  DataDocumentPackage<UserProfile> userprofile;
  DataDocumentPackage<User> user;
  UserDatabase({@required this.uid}) {
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
  final int referralScore;
  final String referralLink;

  User({
    @required this.id,
    @required this.name,
    @required this.referralScore,
    @required this.referralLink,
  });

  factory User.fromData({@required String id, @required dynamic data}) {
    if (data != null) {
      return User(
        id: id,
        name: data['name'],
        referralScore: data['referralScore'] ?? 0,
        referralLink: data['referralLink'],
      );
    } else {
      return User(
        id: id,
        name: 'Anonym',
        referralLink: null,
        referralScore: 0,
      );
    }
  }
}
