import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:universal_commons/platform_check.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleSignInLogic {
  Future<AuthCredential?> getAuthCredentials() async {
    if (PlatformCheck.isMacOS) {
      return _signInWithGoogleMacOS();
    }
    final googleSignIn = GoogleSignIn(
      signInOption: SignInOption.standard,
      scopes: [
        'email',
      ],
    );
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('Google Account is Null');
        return null;
      }
      final credentials = await googleSignInAccount.authentication;

      return GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );
    } catch (e) {
      print('Failure!');
      print(e);
      return null;
    }
  }

  Future<AuthCredential?> _signInWithGoogleMacOS() async {
    try {
      final id = ClientId(
        dotenv.env['GOOGLE_SIGN_IN_CLIENT_ID'] ?? 'MissingENVClientID',
        dotenv.env['GOOGLE_SIGN_IN_CLIENT_SECRET'] ?? 'MissingENVClientSecret',
      );
      final scopes = [
        'email',
      ];
      final client = Client();
      final credentials = await obtainAccessCredentialsViaUserConsent(
        id,
        scopes,
        client,
        (String url) => launch(url),
      );
      client.close();

      return GoogleAuthProvider.credential(
        accessToken: credentials.accessToken.data,
        idToken: credentials.idToken,
      );
    } catch (e) {
      return null;
    }
  }
}
