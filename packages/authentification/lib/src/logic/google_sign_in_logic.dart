import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInLogic {
  Future<AuthCredential?> getAuthCredentials() async {
    final googleSignIn = GoogleSignIn(
      signInOption: SignInOption.standard,
      scopes: [
        'email',
      ],
    );
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final credentials = await googleSignInAccount.authentication;

      return GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );
    } catch (e) {
      return null;
    }
  }
}
