//@dart=2.11
import 'dart:async';

import 'package:authentification/src/models/auth_user.dart';
import 'package:authentification/src/models/authentification_status.dart';
import 'package:authentification/src/models/user_id.dart';
import 'package:bloc/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

class AuthentificationBloc extends BlocBase {
  final FirebaseAuth _firebaseAuth;
  final _authentificationStatusSubject =
      BehaviorSubject<AuthentificationStatus>.seeded(
          LoadingAuthentificationStatus());

  AuthentificationBloc({
    @required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth {
    _initializeFirebaseAuthStream();
  }

  final _streamSubscriptions = <StreamSubscription>[];

  Future<void> _initializeFirebaseAuthStream() async {
    _streamSubscriptions.add(
      _firebaseAuth.authStateChanges().listen((user) {
        if (user == null) {
          _authentificationStatusSubject.sink
              .add(NotLoggedInAuthentificationStatus());
        } else {
          final authUser = AuthUser.fromFirebaseUser(user);
          _authentificationStatusSubject.sink
              .add(AuthentifiedAuthentificationStatus(authUser: authUser));
        }
      }),
    );
  }

  Stream<AuthentificationStatus> get authentificationStatus =>
      _authentificationStatusSubject;

  AuthentificationStatus get authentificationStatusValue =>
      _authentificationStatusSubject.valueWrapper.value;

  UserId get userId => _firebaseAuth.currentUser != null
      ? UserId(_firebaseAuth.currentUser.uid)
      : null;

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  void dispose() {
    _authentificationStatusSubject.close();
    for (final subscription in _streamSubscriptions) subscription.cancel();
  }
}
