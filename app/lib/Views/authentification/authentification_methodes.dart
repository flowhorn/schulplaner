import 'package:authentification/authentification_blocs.dart';
import 'package:authentification/authentification_models.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'link_email_view.dart';
import 'package:authentification/authentification_widgets.dart';

class AuthenticationMethodes extends StatelessWidget {
  AuthenticationMethodes();
  @override
  Widget build(BuildContext context) {
    final myAuthProvidersBloc = BlocProvider.of<MyAuthProvidersBloc>(context);
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).signinmethodes),
      body: SingleChildScrollView(
        child: StreamBuilder<List<AuthProviderType>>(
          stream: myAuthProvidersBloc.providersList,
          builder: (BuildContext context, snapshot) {
            if (snapshot.data != null) {
              final authProviders = snapshot.data ?? [];
              return Column(
                children: <Widget>[
                  FormHeader(bothlang(context,
                      de: 'Meine Anmeldemethoden', en: 'My Sign-In methodes')),
                  if (!authProviders.containsLinkedProviders())
                    Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(bothlang(context,
                            de: 'Anmeldung übersprungen',
                            en: 'Sign-In skipped')),
                        subtitle: Text(bothlang(context,
                            de: 'Du hast noch keine Anmeldemethode hinzugefügt. Füge besser jetzt eine hinzu!',
                            en: "You haven't added any Sign-In methode. Do it know!")),
                        /*
                            trailing: true ? null: FlatButton(
                              onPressed: () {
                                //pushWidget(context, LoginAdvantagesView());
                              },
                              child: Text(
                                getString(context).learnmore.toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              textColor: getAccentColor(context),
                            ),
                            */
                      ),
                    ),
                  for (final authProviderType in authProviders)
                    AuthProviderElement(
                      authProviderType: authProviderType,
                    ),
                  SizedBox(
                    height: 8.0,
                  ),
                  FormDivider(),
                  FormHeader(bothlang(context,
                      de: 'Anmeldemethode hinzufügen',
                      en: 'Add sign-in method')),
                  if (!authProviders.isLinkedWithEmailSignIn())
                    Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.red,
                            ),
                            title: Text(getString(context).linkemail),
                            subtitle: Text(bothlang(context,
                                de: 'Melde dich von all deinen Geräten mit deiner Email-Adresse und einem Passwort an',
                                en: 'Sign in from all your devices using your email & password')),
                          ),
                          SizedBox(
                            height: 52.0,
                            child: FlatButton(
                              onPressed: () {
                                pushWidget(context, LinkEmailView());
                              },
                              child:
                                  Text(getString(context).linkit.toUpperCase()),
                              textColor: getAccentColor(context),
                            ),
                          ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                  SizedBox(
                    height: 8.0,
                  ),
                  if (!authProviders.isLinkedWithGoogleSignIn())
                    Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              CommunityMaterialIcons.google,
                              color: Colors.blue,
                            ),
                            title: Text(bothlang(context,
                                de: 'Google-Verknüpfung', en: 'Google-Link')),
                            subtitle: Text(bothlang(context,
                                de: 'Melde dich von all deinen Geräten mit deinem Google-Konto an',
                                en: 'Sign in from all your devices using your Google account')),
                          ),
                          SizedBox(
                            height: 52.0,
                            child: FlatButton(
                              onPressed: () {
                                linkAuthentificationGoogle(context);
                              },
                              child:
                                  Text(getString(context).linkit.toUpperCase()),
                              textColor: getAccentColor(context),
                            ),
                          ),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                  SizedBox(
                    height: 8.0,
                  ),
                  FormDivider(),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void linkAuthentificationGoogle(BuildContext context) async {
    final myAuthProvidersBloc = BlocProvider.of<MyAuthProvidersBloc>(context);
    final linkingFuture = myAuthProvidersBloc.tryLinkWithGoogleSignIn();
    final stateSubject =
        BehaviorSubject<SheetContent>.seeded(LoadingSheetContent());
    final stateSheet = StateSheet(stream: stateSubject);
    // ignore: unawaited_futures
    linkingFuture.then((linkingResult) {
      if (linkingResult == true) {
        stateSubject.add(successfulSheetContent);
      } else {
        stateSubject.add(errorSheetContent);
      }
    });
    await stateSheet.showWithAutoPop(
      context,
      future: linkingFuture,
      delay: Duration(milliseconds: 250),
    );
  }
}

class AuthProviderElement extends StatelessWidget {
  final AuthProviderType authProviderType;

  const AuthProviderElement({Key key, this.authProviderType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (authProviderType is EmailAuthProviderType) {
      return EmailAuthProviderTile(authProviderType: authProviderType);
    }
    if (authProviderType is GoogleAuthProviderType) {
      return GoogleAuthProviderTile(authProviderType: authProviderType);
    }
    return Card(
      child: ListTile(
        title: Text(authProviderType.firebaseProviderId),
      ),
    );
  }
}
