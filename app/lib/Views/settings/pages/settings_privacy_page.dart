import 'package:bloc/bloc_provider.dart';
import 'package:export_user_data_client/export_user_data_client.dart';
import 'package:export_user_data_client_implementation/export_user_data_client_implementation.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/userdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/user_database_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_website/schulplaner_website_pages.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView();

  @override
  Widget build(BuildContext context) {
    final UserDatabase? userDatabase =
        BlocProvider.of<UserDatabaseBloc>(context).userDatabase;
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: MyAppHeader(
        title: getString(context).privacy,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(4.0)),
              if (userDatabase != null)
                FormSection(
                  title: getString(context).actions,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete_forever),
                        title: Text(getString(context).remove_data),
                        onTap: () {
                          void _launchURL() async {
                            dynamic url =
                                'mailto:danielfelixplay@gmail.com?subject=${getString(context).remove_data}&body= UID: ${userDatabase.uid}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.collections_bookmark),
                        title: Text(getString(context).retrieve_data),
                        onTap: () {
                          pushWidget(
                            context,
                            BlocProvider(
                              bloc: ExportUserDataClientBloc(
                                downloadService: MockDownloadService(),
                                exportUserDataService:
                                    FirestoreExportUserDataService(
                                  userId: userDatabase.uid,
                                  firestore:
                                      userDatabase.getRootReference().firestore,
                                ),
                              ),
                              child: ExportUserDataPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text(getString(context).privacy_policy),
                        onTap: () {
                          openPrivacyPolicyPage(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_mail),
                        title: Text(getString(context)
                            .contact_data_protection_commissioner),
                        onTap: () {
                          void _launchURL() async {
                            dynamic url =
                                'mailto:danielfelixplay@gmail.com?subject=${getString(context).privacy}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }

                          _launchURL();
                        },
                      ),
                    ],
                  ),
                ),
              Padding(padding: const EdgeInsets.all(4.0)),
              FormSection(
                title: getString(context).privacy_policy,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(getString(context).policy_text_header),
                    ),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text(getString(context).policy_text_1),
                    ),
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text(getString(context).policy_text_2),
                    ),
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text(getString(context).policy_text_3),
                    ),
                    ListTile(
                      leading: Icon(Icons.memory),
                      title: Text(getString(context).policy_text_4),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextButton(
                        onPressed: () {
                          openPrivacyPolicyPage(context);
                        },
                        child: Text(getString(context).privacy_policy),
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
            ],
          )
        ],
      ),
    );
  }
}

Future<void> openPrivacyPolicyPage(BuildContext context) {
  return pushWidget(
    context,
    Scaffold(
      appBar: AppBar(
        title: Text(getString(context).privacy_policy),
      ),
      body: SingleChildScrollView(
        child: PrivacyPageContent(),
      ),
    ),
  );
}
