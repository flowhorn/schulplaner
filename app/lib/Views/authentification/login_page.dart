import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/AppSettings.dart';
import 'package:schulplaner8/Views/Help.dart';
import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:authentification/authentification_widgets.dart';
import 'package:schulplaner8/Views/authentification/email_page.dart';
import 'package:schulplaner8/Views/settings/pages/settings_privacy_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 24.0),
                    CircleAvatar(
                      child: Icon(
                        Icons.lock,
                        size: 44.0,
                        color: Colors.white,
                      ),
                      backgroundColor: getAccentColor(context),
                      radius: 44.0,
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      getString(context).selectmethode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    LoginInnerPage(),
                    SizedBox(height: 32.0),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LoginHelpLinks(),
          ),
        ],
      ),
    );
  }
}

class LoginInnerPage extends StatelessWidget {
  LoginInnerPage();

  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);
    return Padding(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
      child: StreamBuilder<SignInState>(
        initialData: SignInState.none,
        stream: signInBloc.signInState,
        builder: (context, snapshot) {
          final signInState = snapshot.data;
          if (signInState == SignInState.loading) {
            return _LoadingSignInState();
          }
          if (signInState == SignInState.successfull) {
            return _SuccessfullSignInState();
          }
          if (signInState == SignInState.failed) {
            return _FailedSignInState();
          }
          return _SignInMethodes();
        },
      ),
    );
  }
}

class _SuccessfullSignInState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final signInBloc = BlocProvider.of<SignInBloc>(context);
        signInBloc.clear();
      },
      child: SizedBox(
        height: 210.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.done_outline,
                color: Colors.green,
                size: 48.0,
              ),
              SizedBox(height: 12.0),
              Text(
                bothlang(
                  context,
                  de: 'Anmeldung erfolgreich!',
                  en: 'Sign In successful!',
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FailedSignInState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);
    return Column(children: <Widget>[
      SizedBox(height: 60.00),
      Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60.0,
      ),
      Text(
        bothlang(
          context,
          de: 'Authentifizierungsfehler',
          en: 'Authentication error',
        ),
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      SizedBox(height: 100.0),
      InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.red),
        ),
        onTap: () {
          signInBloc.clear();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: FlatButton.icon(
            highlightColor: Colors.white,
            icon: Icon(
              Icons.arrow_left_outlined,
              color: Colors.red,
            ),
            label: Text(
              bothlang(
                context,
                de: 'Zurück',
                en: 'Go back',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              final signInBloc = BlocProvider.of<SignInBloc>(context);
              signInBloc.clear();
            },
          ),
        ),
      ),
    ]);
  }
}

class _SignInMethodes extends StatelessWidget {
  const _SignInMethodes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          SignInAppleButton(),
          FormSpace(6),
          Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: getDividerColor(context)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              SignInGoogleButton(),
              AuthentificationLoginTile(
                iconData: Icons.email,
                color: Colors.redAccent,
                title: 'Email',
                onTap: () {
                  pushWidget(
                    context,
                    EmailView(),
                  );
                },
              ),
              SignInSkipButton(),
            ]),
          ),
        ],
      ),
    );
  }
}

class _LoadingSignInState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
            SizedBox(height: 12.0),
            Text(
              bothlang(
                context,
                de: 'Bitte habe einen Moment Geduld...',
                en: 'Please be patient for a moment...',
              ),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                color: getAccentColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginHelpLinks extends StatelessWidget {
  const LoginHelpLinks({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(getString(context).signinhasadvantages),
              subtitle: Text(getString(context).signinhasadvantages_desc),
            ),
            _HelpActions(),
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      elevation: 12.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: getDividerColor(context),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
    );
  }
}

class _HelpActions extends StatelessWidget {
  const _HelpActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: LabeledIconButtonSmall(
          onTap: () {
            pushWidget(
              context,
              HelpView(),
            );
          },
          iconData: Icons.help,
          name: getString(context).help,
        )),
        Expanded(
            child: LabeledIconButtonSmall(
          onTap: () {
            pushWidget(
              context,
              PrivacyView(),
            );
          },
          iconData: Icons.security,
          name: getString(context).privacy,
        )),
        Expanded(
            child: LabeledIconButtonSmall(
          onTap: () {
            pushWidget(
              context,
              AppSettingsView(),
            );
          },
          iconData: Icons.settings,
          name: getString(context).settings,
        )),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
