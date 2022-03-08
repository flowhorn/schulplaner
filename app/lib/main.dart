import 'package:authentification/authentification_blocs.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:schulplaner8/Views/AppState.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/dynamic_links/src/bloc/dynamic_link_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_commons/platform_check.dart';
import 'schulplaner_blocs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  if (!PlatformCheck.isWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  try {
    if (PlatformCheck.isAndroid) {
      /*
      final requestConfiguration = RequestConfiguration(
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes);
      // ignore: unawaited_futures
      MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    */
    }
  } catch (e) {
    ;
  }

  final dynamicLinksLogic = DynamicLinksBloc(FirebaseDynamicLinks.instance);

  runApp(
    OverlaySupport.global(
      child: SchulplanerBlocs.create(
        dynamicLinksBloc: dynamicLinksLogic,
        firebaseAuth: FirebaseAuth.instance,
        child: Builder(
          builder: (context) {
            final authentificationBloc =
                BlocProvider.of<AuthentificationBloc>(context);
            final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
            return AppSettingsStateHead(
              appSettingsBloc: appSettingsBloc,
              dynamicLinksLogic: dynamicLinksLogic,
              authentificationBloc: authentificationBloc,
            );
          },
        ),
      ),
    ),
  );
}
