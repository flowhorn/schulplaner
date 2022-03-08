import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:universal_commons/platform_check.dart';

class AppleSignInLogic {
  Future<AuthCredential?> getAuthCredentials() async {
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

  static Future<bool> isSignInAvailable() async {
    if (PlatformCheck.isWeb) return false;
    return true;
  }
}
