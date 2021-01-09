import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:schulplaner8/Helper/LogAnalytics.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/settings/src/about_page/about_page_header.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:share/share.dart';
import 'package:universal_io/prefer_universal/io.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).about,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AboutPageHeader(),
            _AboutApp(),
            _ContactUs(),
            _SocialMedia(),
            _Financing(),
            FormSpace(16.0),
          ],
        ),
      ),
    );
  }
}

class _AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: BothLangString(
        de: 'Über die Schulplaner-App',
        en: 'About the Schoolplanner-App',
      ).getText(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormSectionText(
              text: DefaultTextSpan(
            context,
            BothLangString(
              de: 'Die Schulplaner-App ist ein digitaler Schulplaner.\nEr erleichtert dir die Organisation deines Schulalltags.\nDu kannst ihn von all deinen Geräten verwenden und gemeinsam mit deinen Mitschülern verwalten. So muss auch nur noch einer die Hausaufgaben oder Stunden eintragen.',
              en: 'The Schoolplanner-App is a digital Schoolplanner.\nIt simplifies the organisation of your daily schoollife.\nYou can use it with all your devices and together with your classmates. Then only one has to enter tasks and lessons.',
            ).getText(context),
          )),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.star),
            title: Text(getString(context).rate_us),
            onTap: () {
              if (Platform.isAndroid || Platform.isIOS) {
                LaunchReview.launch();
              } else {
                launch(
                    'https://schulplaner.web.app/'); //todo(flowhorn) set link to download section
              }
            },
          )
        ],
      ),
    );
  }
}

class _ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: BothLangString(
              de: 'Du möchtest uns gerne kontaktieren?',
              en: 'Do you want to contact us?')
          .getText(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormSectionText(
              text: DefaultTextSpan(
            context,
            BothLangString(
              de: 'Wir melden uns schnell bei dir zurück.\nEgal ob es um Verbesserungsvorschläge, Wünsche, Bugs oder Hilfe geht. Wir helfen dir gerne.',
              en: 'We respond quickly. Whether you have improvements, wishes, bugs or you need help. We like to help you.',
            ).getText(context),
          )),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              getString(context).contact_us,
            ),
            subtitle: Text('danielfelixplay@gmail.com'),
            onTap: () {
              Future<void> _launchURL() async {
                dynamic url =
                    'mailto:danielfelixplay@gmail.com?subject=${getString(context).apptitle}';
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
            leading: Icon(CommunityMaterialIcons.discord),
            title: Text('Support-Server'),
            onTap: () {
              launch('https://discord.gg/uZyK7Tf');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bug),
            title: Text(bothlang(context,
                de: 'Erstelle ein Issue (GitHub)',
                en: 'Create an issue (GitHub)')),
            onTap: () {
              launch(
                  'https://github.com/flowhorn/schulplaner/issues/new/choose');
            },
          )
        ],
      ),
    );
  }
}

class _SocialMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Social Media',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormSectionText(
              text: DefaultTextSpan(
            context,
            BothLangString(
              de: 'Möchtest du mehr über die Entwicklung der App, neue Features und uns erfahren? ',
              en: 'Du you want to know more about the development of the app, features and us?',
            ).getText(context),
          )),
          ListTile(
            leading: Icon(
              CommunityMaterialIcons.instagram,
              color: Colors.pink,
            ),
            title: Text(
              'Instagram (@schulplaner.app)',
              style: TextStyle(color: Colors.pink),
            ),
            onTap: () {
              launch('https://www.instagram.com/schulplaner.app');
            },
          ),
          ListTile(
            leading: Icon(
              CommunityMaterialIcons.twitter,
              color: Colors.lightBlue,
            ),
            title: Text(
              'Twitter (@SchulplanerApp)',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onTap: () {
              launch('https://twitter.com/SchulplanerApp');
            },
          ),
        ],
      ),
    );
  }
}

class _Financing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormSection(
        title: BothLangString(
          de: 'Wie finanziert sich Schulplaner',
          en: 'How is Schoolplanner financed',
        ).getText(context),
        child: Column(
          children: <Widget>[
            FormSectionText(
                text: DefaultTextSpan(
                    context,
                    BothLangString(
                      de: '''Die Schulplaner App ist zu 100% kostenlos und werbefrei. Das wirft die Frage auf wie sich die App finanziert.
\nIch bin selber noch Schüler und habe die App in meiner Freizeit entwickelt. Bislang bezahle ich die Kosten für die Datenbank etc. selber. Über jegliche Unterstützungen wäre ich daher sehr dankbar um das Projekt weiter am Leben zu halten.
''',
                      en: '''The school planner app is 100% free and ad-free. This raises the question of how the app is financed.
\nI'm still a student and have developed the app in my free time. So far, I pay the cost of the database, etc. by myself. I would be really grateful for any support, to keep the project alive.
''',
                    ).getText(context))),
            ListTile(
              leading: Icon(
                CommunityMaterialIcons.heart,
                color: Colors.red,
              ),
              title: Text(
                getString(context).learnmore,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                launch('https://schulplaner.web.app/support');
                LogAnalytics.SupportAppClickAbout();
              },
            ),
          ],
        ));
  }
}
