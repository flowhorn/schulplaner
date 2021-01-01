import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageMe extends StatelessWidget {
  static const aboutMeString = BothLangString(de: "Über mich", en: "About me");

  static const aboutMeText1 = BothLangString(
    de: '''Hi, ich bin Felix, der Entwickler der Schulplaner App. Vor vier Jahren (2016) habe ich die erste Version der Schulplaner App veröffentlicht. Mit der App habe ich das Programmieren gelernt und gleichzeitig mit vielen Menschen zusammen etwas großartiges entwickelt.''',
    en: "Hello, I'm Felix, the developer of the school planner app. Four years ago (2016) I ran the first version of the school planner app. I learned programming with the app and heard something together with many people.",
  );

  static const aboutMeText2 = BothLangString(
      de: '''Inzwischen wurde die Schulplaner App über 200.000 Mal heruntergeladen und hat sich mit euch zusammen ständig verbessert. Da ich mittlerweile studiere, werde ich nicht mehr so viel Zeit dafür haben, die App selber weiterzuentwickeln und möchte das Projekt in eure Hände abgeben. Aber mit eurer Hilfe zusammen wird die Entwicklung der App weiter voranschreiten.''',
      en: "The school planner app has now been downloaded over 200,000 times and has continuously improved with you. Since I'm now studying, I won't have that much time to develop the app myself and would like to hand the project over to your hands. But with your help, the app will continue to develop.");
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: aboutMeString.getText(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _Image(),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    aboutMeText1.getText(context),
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              aboutMeText2.getText(context),
              textAlign: TextAlign.start,
            ),
          ),
          ListTile(
            leading: Icon(
              CommunityMaterialIcons.instagram,
              color: Colors.pink,
            ),
            title: Text(
              "Instagram (@felix.weuth)",
              style: TextStyle(color: Colors.pink),
            ),
            onTap: () {
              launch("https://www.instagram.com/felix.weuth");
            },
          ),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 45,
      backgroundColor: getDividerColor(context),
      child: CircleAvatar(
        radius: 43,
        backgroundImage: AssetImage(
          'assets/about_me_felix.jpg',
        ),
      ),
    );
  }
}
