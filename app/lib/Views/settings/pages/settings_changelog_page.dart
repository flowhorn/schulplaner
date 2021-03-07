//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class ChangelogItem {
  int versioncode;
  String versionname, releasedate;
  List<String> changes_de, changes_en;
  ChangelogItem({
    this.versioncode,
    this.versionname,
    this.releasedate,
    this.changes_de,
    this.changes_en,
  });
}

class ChangelogView extends StatelessWidget {
  final List<ChangelogItem> changeloglist = [
    ChangelogItem(
      versioncode: 611,
      versionname: '10',
      releasedate: '2020-10-01',
      changes_de: [
        'Überarbeitung des Designs',
        'Neue Seitennavigation für Tablets/Web/Desktop',
        'Unglaublich viele Bugfixes',
      ],
      changes_en: [
        'Improved design',
        'New SideNavigation for Tablets/Web/Desktop',
        'So many Bugfixes',
      ],
    ),
    ChangelogItem(
      versioncode: 601,
      versionname: '9.1',
      releasedate: '2020-08-26',
      changes_de: ['Apple Sign In', 'Weitere Bugfixes'],
      changes_en: [
        'Apple Sign In'
            'bugfixes',
      ],
    ),
    ChangelogItem(
      versioncode: 600,
      versionname: '9.0.0',
      releasedate: '2020-08-10',
      changes_de: [
        'Allgemeine Verbesserungen der Performance und Stabilität',
        'Bugs, welche beim Entfernen von Lehrern/Orten aufgetreten sind, wurden gefixed'
      ],
      changes_en: [
        'general improvements of performance & stability'
            'bugfixes',
      ],
    ),
    ChangelogItem(
      versioncode: 500,
      versionname: '8.11.0',
      releasedate: '2019-09-04',
      changes_de: [
        'Es gibt nun eine neue moderne Feriendatenbank. Damit wird es zukünftig noch mehr und besser gepflegte Ferienpakete geben',
        'Du kannst deinen Stundenplan jetzt endlich ausdrucken [BETA]',
        'viele Bugfixes',
      ],
      changes_en: [
        'new holiday database',
        'print timetable',
        'many bugfixes',
      ],
    ),
    ChangelogItem(
      versioncode: 496,
      versionname: '8.10.0',
      releasedate: '2019-08-06',
      changes_de: [
        'unglaublich viele UI-Verbesserungen',
        'viele Bugfixes',
        'Weitermpfehlungsprogramm mit Dynamic Links',
        "Dynamic Links für's Teilen von Kursen und Klassen",
      ],
      changes_en: [
        'many UI-Improvements',
        'many bugfixes',
        'Referrals with Dynamic Links',
        'Dynamic Links for sharing courses and classes',
      ],
    ),
    ChangelogItem(
        versioncode: 488,
        versionname: '8.9.2',
        changes_de: [
          'interne Verbesserungen',
          'Erstellen von Kopien eines Planers',
          'Verbesserte Chatansicht',
          'Statistiken für Noten',
        ],
        changes_en: [
          'internal improvements',
          'Create a copy of a planner',
          'improved chatview',
          'stats for grades'
        ],
        releasedate: '2019-07-20'),
    ChangelogItem(
        versioncode: 486,
        versionname: '8.9.0',
        changes_de: [
          'verbesserter Tablet-Modus',
          'Anzeige des Namens im Klassenchat',
        ],
        changes_en: [
          'improved tablet-mode',
          'name in class chat',
        ],
        releasedate: '2019-06-13'),
    ChangelogItem(
        versioncode: 478,
        versionname: '8.7.4',
        changes_de: [
          'Option zum Teilen von Hausaufgaben',
          'Stärkere Betonung von Klausuren und Tests in der Timeline',
          'Stunden in der Timeline können optional ausgeblendet werden',
        ],
        changes_en: [
          'option to share homework',
          'enhanced visibility of exams and tests',
          'lessons in the timeline can be optionally disabled',
        ],
        releasedate: '2019-05-20'),
    ChangelogItem(
        versioncode: 471,
        versionname: '8.7',
        changes_de: [
          'Avatar und Bild für dein Profil',
          'Neues Berechtigungssystem in Fächern und Klassen'
              'Bugfixes',
        ],
        changes_en: [
          'avatar and picture for the profile',
          'new permission system for courses and classes',
          'translation-fixes and bugfixes'
        ],
        releasedate: '2019-05-06'),
    ChangelogItem(
        versioncode: 469,
        versionname: '8.6.1',
        changes_de: [
          'Verbesserte Unterstützung für die 0. Stunde',
          'Bugfixes',
        ],
        changes_en: [
          'improved support for 0. lesson',
          'translation-fixes and bugfixes'
        ],
        releasedate: '2019-04-11'),
    ChangelogItem(
        versioncode: 468,
        versionname: '8.6.0',
        changes_de: [
          'einige Performance-Verbesserungen',
          'Bugfixes',
        ],
        changes_en: ['several Performance-Improvements', 'bugfixes'],
        releasedate: '2019-04-01'),
    ChangelogItem(
        versioncode: 467,
        versionname: '8.5.3',
        changes_de: [
          'Einrichtungsassistent',
          'Erweiterte Datei-Auswahl, sowie Dateiauswahl für das Profilbild',
          'Bugfixes',
        ],
        changes_en: [
          'Setup-assistent',
          'Advanced fileselection as well as file selection for the profile picture',
          'bugfixes'
        ],
        releasedate: '2019-03-27'),
    ChangelogItem(
        versioncode: 460,
        versionname: '8.5.0',
        changes_de: [
          'Briefe für Klassen und Fächer. Gibt es Ankündigungen oder wichtige Mitteilungen? Mit den neuen Briefen kannst du alle Mitschüler schnell und einfach erreichen.',
          'Bugfixes',
        ],
        changes_en: [
          'Letters for classes and subjects. Are there any announcements or important messages? With the letters you can reach all classmates quickly and easily.',
          'bugfixes'
        ],
        releasedate: '2019-03-17'),
    ChangelogItem(
        versioncode: 457,
        versionname: '8.4.4',
        changes_de: [
          'Ausgefallene Stunden werden nun für die Berechnung der nächsten Stunde berücksichtigt',
          'Extras für Notenprofile',
          'Dateiablage',
        ],
        changes_en: [
          "lessoninfos are now used for the next lesson's calculation",
          'Extras for note profiles',
          'File storage'
        ],
        releasedate: '2019-03-12'),
    ChangelogItem(
        versioncode: 450,
        versionname: '8.4.3',
        changes_de: [
          'Ausweitung des neuen Designs',
          'Bugfixes für Notenprofile sowie das Widget',
        ],
        changes_en: [
          'advanced redesign',
          'bugfixes for the gradeprofiles and the widget',
        ],
        releasedate: '2019-03-05'),
    ChangelogItem(
        versioncode: 447,
        versionname: '8.4.2',
        changes_de: [
          'Die Über-Seite wurde neu gestaltet',
          'weitere Bugfixes',
          'Designverbesserungen',
          'Darkmode für das Widget kann nun einzelnd aktiviert werden',
        ],
        changes_en: [
          'the About-Page has been redesigned',
          'more bugfixes',
          'design-improvements',
          'darkmode for the widget can be enabled seperatly',
        ],
        releasedate: '2019-03-04'),
    ChangelogItem(
        versioncode: 444,
        versionname: '8.4.0',
        changes_de: [
          'Bugfixes am Berechtigungssystem',
          'Notenprofile für einzelne Fächer',
          'eingebauter Changelog',
          '[Android] Darkmode für das Stundenplan-Widget',
        ],
        changes_en: [
          'built-in Changelog',
          'Bugfixes for the Permissionsystem',
          'Gradeprofiles',
          '[Android] Darkmode for the timetable-widget',
        ],
        releasedate: '2019-03-03'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).changelog),
      backgroundColor: getBackgroundColor(context),
      body: ListView(
        children: [
          for (final item in changeloglist)
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(item.versionname),
                      trailing: Text(
                        item.versioncode.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final change
                              in (getString(context).languagecode == 'de'
                                  ? item.changes_de
                                  : item.changes_en))
                            Text(
                              '• ' + change,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.today),
                      title: Text(item.releasedate != null
                          ? getDateStringSmall(item.releasedate)
                          : '-'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
