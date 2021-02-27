//@dart=2.11
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:universal_commons/platform_check.dart';

class AppleSignInLogic {
  Future<AuthCredential> getAuthCredentials() async {
    if (PlatformCheck.isIOS || PlatformCheck.isMacOS) {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      return credential;
    }
    return null;
  }

  Future<User> signInWithFirebaseOAuth() async {
    return await FirebaseAuthOAuth()
        .openSignInFlow("apple.com", [], {"locale": "en"});
  }

  static Future<bool> isSignInAvailable() {
    if (PlatformCheck.isIOS || PlatformCheck.isMacOS) {
      return SignInWithApple.isAvailable();
    }
    if (PlatformCheck.isAndroid) return Future.value(true);
    return Future.value(false);
  }
}
