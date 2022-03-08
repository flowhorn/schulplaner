import 'package:authentification/src/logic/apple_sign_in_logic.dart';
import 'package:authentification/src/logic/google_sign_in_logic.dart';
import 'package:authentification/src/models/sign_in_state.dart';
import 'package:bloc/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_commons/platform_check.dart';

class SignInBloc extends BlocBase {
  SignInBloc({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  final _signInSubject = BehaviorSubject<SignInState>.seeded(SignInState.none);

  void _setSignInState(SignInState signInState) {
    _signInSubject.add(signInState);
  }

  void clear() {
    _setSignInState(SignInState.none);
  }

  Stream<SignInState> get signInState => _signInSubject;

  Future<void> tryGoogleSignIn() async {
    _signInSubject.add(SignInState.loading);
    try {
      final credentials = await GoogleSignInLogic().getAuthCredentials();
      final userCredentials = credentials != null
          ? await _firebaseAuth.signInWithCredential(credentials)
          : null;
      if (userCredentials != null) {
        _signInSubject.add(SignInState.successfull);
      } else {
        _signInSubject.add(SignInState.failed);
      }
    } catch (e) {
      _signInSubject.add(FailedSignInState(e.toString()));
    }
  }

  Future<void> tryAppleSignIn() async {
    _signInSubject.add(SignInState.loading);
    try {
      final credentials = await AppleSignInLogic().getAuthCredentials();
      final userCredentials = credentials != null
          ? await _firebaseAuth.signInWithCredential(credentials)
          : null;
      if (userCredentials != null) {
        _signInSubject.add(SignInState.successfull);
      } else {
        _signInSubject.add(SignInState.failed);
      }
    } catch (e) {
      _signInSubject.add(FailedSignInState(e.toString()));
    }
  }

  Future<void> tryAnonymouslySignIn() async {
    _signInSubject.add(SignInState.loading);
    try {
      final UserCredential? userCredentials =
          await _firebaseAuth.signInAnonymously();
      if (userCredentials != null) {
        _signInSubject.add(SignInState.successfull);
      } else {
        _signInSubject.add(SignInState.failed);
      }
    } catch (error) {
      print(error);
      _signInSubject.add(FailedSignInState(error.toString()));
    }
  }

  Future<void> tryCustomAuthKeySignIn(String customAuthKey) async {
    _signInSubject.add(SignInState.loading);
    try {
      final UserCredential? userCredentials =
          await _firebaseAuth.signInWithCustomToken(customAuthKey);
      if (userCredentials != null) {
        _signInSubject.add(SignInState.successfull);
      } else {
        _signInSubject.add(SignInState.failed);
      }
    } catch (error) {
      print(error);
      _signInSubject.add(FailedSignInState(error.toString()));
    }
  }

  Future<void> sendPasswordResetRequest({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isAppleSignInAvailable() {
    return AppleSignInLogic.isSignInAvailable();
  }

  @override
  void dispose() {
    _signInSubject.close();
  }
}
