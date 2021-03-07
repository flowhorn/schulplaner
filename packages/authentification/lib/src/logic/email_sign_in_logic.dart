import 'package:firebase_auth/firebase_auth.dart';

class EmailCredential {
  AuthCredential getAuthCredentials(
      {required String email, required String password}) {
    return EmailAuthProvider.credential(
      email: email,
      password: password,
    );
  }
}
