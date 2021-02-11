import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:authentification/src/logic/google_sign_in_logic.dart';
import 'package:authentification/src/models/auth_provider.dart';
import 'package:bloc/bloc_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';

class MyAuthProvidersBloc extends BlocBase {
  final FirebaseAuth _firebaseAuth;
  final _providersListSubject = BehaviorSubject<List<AuthProviderType>>();

  final _linkingStateSubject =
      BehaviorSubject<SignInState>.seeded(SignInState.none);

  MyAuthProvidersBloc(
      {required FirebaseAuth firebaseAuth,
      required AuthentificationBloc authentificationBloc})
      : _firebaseAuth = firebaseAuth {
    authentificationBloc.authentificationStatus.listen((authStatus) {
      if (authStatus is AuthentifiedAuthentificationStatus) {
        final authUser = authStatus.authUser;
        _providersListSubject.add(authUser.authProviders);
      } else {
        _providersListSubject.add([]);
      }
    });
  }

  Stream<List<AuthProviderType>> get providersList => _providersListSubject;

  Stream<SignInState> get linkingState => _linkingStateSubject;

  Future<bool> tryLinkWithGoogleSignIn() async {
    _linkingStateSubject.add(SignInState.loading);
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      try {
        final googleAuthCredentials =
            await GoogleSignInLogic().getAuthCredentials();
        if (googleAuthCredentials != null) {
          final userCredentials =
              await firebaseUser.linkWithCredential(googleAuthCredentials);
          if (userCredentials != null) {
            _linkingStateSubject.add(SignInState.successfull);
            return true;
          } else {
            _linkingStateSubject.add(SignInState.failed);
          }
        }
      } catch (_) {
        _linkingStateSubject.add(SignInState.failed);
      }
    }
    return false;
  }

  @override
  void dispose() {
    _providersListSubject.close();
    _linkingStateSubject.close();
  }
}
