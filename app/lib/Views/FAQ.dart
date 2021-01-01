import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class FAQ_Entry {
  IconData icon;
  String title, content;
  FAQ_Entry({this.title, this.content, this.icon});
}

List<FAQ_Entry> getFAQ_German() {
  return [
    FAQ_Entry(
      title:
          "Wie kann man die Anzahl der in der Timeline angezeigten Buchstaben der Kurznamen ändern?",
      content:
          "Gehe dazu unter Einstellungen/Konfigurieren/Allgemein. Dort kannst du zwischen 1-4 angezeigten Buchstaben auswählen.",
    ),
    FAQ_Entry(
      title: "Wie erstelle ich eine Klasse?",
      content:
          "Um eine Klasse zu erstellen, musst du auf Bibliothek gehen und dort unter dem Punkt „Schulklasse“ auf Erstellen drücken.  Danach kannst du dann den Namen und eine Abkürzung für deine Klasse überlegen. Auch die Farbe deiner Klasse kannst du einstellen.",
    ),
    FAQ_Entry(
      title: "Wie trete ich einer Klasse bei?",
      content:
          "Du kannst ganz einfach einer Klasse beitreten, indem du auf Bibliothek und dann unter dem Punkt Schulklasse auf Beitreten drückst. Dort musst du den öffentlichen Code deiner Klasse eingeben, den du z.b. vom Klassenadmin bekommen kannst.",
    ),
    FAQ_Entry(
      title: "Kann man mehrere Planer gleichzeitig haben?",
      content:
          "Ja. Du kannst weitere Pläne erstellen, indem du unter Einstellungen/Planer verwalten auf Neuer Planer drückst. Danach kannst du zwischen dem alten und dem neu erstellten Plan hin und her switchen.  Alternativ kann man auch oben in der Leiste auf den Namen des Plans drücken und dort den entsprechenden Plan auswählen.",
    ),
    FAQ_Entry(
      title: "Kann man in mehreren Klassen sein?",
      content:
          "Ja. Das geht aber nur indem man unter Einstellungen/Planer verwalten einen weiteren Plan anlegt. Wenn man diesen dann auswählt, kann man da auch einer Klasse beitreten.",
    ),
    FAQ_Entry(
      title: "Wie kann man die Zeiten im Stundenplan anzeigen lassen?",
      content:
          "Dazu musst du unter Einstellungen/Stunden auf Zeitbasierter Stundenplan drücken.",
    ),
    FAQ_Entry(
      title:
          "Die Zeiten der Schulstunden stimmen nicht. Wie kann ich die einstellen?",
      content: "Gehe dazu unter Einstellungen/Stunden auf Stundenzeiten.",
    ),
    FAQ_Entry(
      title: "Kann man die Anzahl der Schulstunden einstellen?",
      content:
          "Ja. Du kannst die Anzahl der Stunden einstellen, indem du unter Einstellungen/Stunden auf Stundenanzahl drückst. Die dort ausgewählte Zahl stunden wird dir dann auch im Stundenplan angezeigt.",
    ),
    FAQ_Entry(
      title: "Wie kann man 12-/AB-Wochen einstellen?",
      content:
          "Dazu musst du unter Einstellungen/Stunden gehen. Dort musst du auf Mehrere Wochentypen gehen. Da kannst du zwischen 2-4 unterschiedlichen Wochentypen wählen.",
    ),
    FAQ_Entry(
      title: "Wie kann ich mir Ferien anzeigen lassen?",
      content:
          "Ferien sind je nach Bundesland unterschiedlich. Du kannst die Ferien deines Bundeslandes unter Einstellungen/Ferien auswählen, indem du auf Feriendatenbank drückst und dein entsprechendes Bundesland auswählst. Momentan werden nur Deutschland und Österreich unterstützt.",
    ),
    FAQ_Entry(
      title: "In dem Widget wird nichts angezeigt. Warum? (Android)",
      content:
          "Um in dem Widget etwas anzeigen zu lassen musst du unter Einstellungen auf Widgets gehen und dort auf Daten aktualisieren drücken. Das muss jedes Mal gemacht werden, wenn sich am Stundenplan etwas ändert.",
    ),
    FAQ_Entry(
      title:
          "Wie kann ich von anderen Geräten außer Android/IOS auf den Stundenplan, etc. zugreifen?",
      content:
          "Die Funktion wird bisher noch nicht unterstützt. Sie wird aber bald hinzugefügt werden.",
    ),
    FAQ_Entry(
      title:
          "Was bedeutet unter Einstellungen/Gehe zu Profil/bearbeiten der Punkt Profilbild (URL)?",
      content:
          "Hier kannst du den Internet Link zu einem Bild eingeben, welches dann als dein Profilbild genutzt wird. Galeriebilder werden momentan noch nicht unterstützt.",
    ),
    FAQ_Entry(
      title: "Kann man Stundenplanänderungen eintragen?",
      content:
          '''Ja, indem man entweder auf das betroffene Fach und dann auf das Plus drückt, oder indem man unter Schnell erstelle auf Info drückt. 
      Es können Ausfälle, Lehrer und Ortsänderungen vorgenommen werden. Das Verlegen einer Stunde wird derzeit nicht unterstützt.
      ''',
    ),
    FAQ_Entry(
      title: "Ist es möglich Hausaufgaben einzutragen?",
      content:
          "Ja. Gehe dazu unter Schnell erstellen auf Aufgabe, oder unter Bibliothek auf Aufgaben und drücke dann auf Neue Aufgabe. ",
    ),
    FAQ_Entry(
      title: "Ist es möglich Klausuren einzutragen?",
      content:
          "Ja. Gehe dazu unter Bibliothek/Klausuren auf Neue Klausur, oder unter Schnell erstellen auf Termin und wähle unter Termintyp Klausur aus.",
    ),
    FAQ_Entry(
      title: "Wie erstellt man ein Fach? ",
      content:
          '''Wenn man in einer Klasse ist, ist es meistens nicht nötig selbst Fächer zu erstellen.
Bevor man ein Fach erstellen kann, muss man unter Bibliothek/Lehrer, die Lehrer eintragen, bei denen man Unterricht hat und unter Bibliothek/Orte, die Orte an denen man Unterricht hat. Alternativ ist dies auch bei der Facherstellung möglich.
Um ein Fach zu erstellen, muss man unter Fächer auf das + drücken. Dort kann man wählen ob man ein Fach komplett selbst erstellen will, ob man eine Vorlage verwenden will oder ob man einem Fach beitreten will. Wenn man einem Fach beitreten will, benötigt man den öffentlichen Code des Fachs. 
''',
    ),
    FAQ_Entry(
      title: "Kann man Fehlzeiten eintragen?",
      content:
          "Ja. Gehe dazu unter Schnell erstellen auf Fehlzeit, oder unter Bibliothek auf Fehlzeiten und drück dort auf Neue Fehlzeit.",
    ),
    FAQ_Entry(
      title: "Wie füge ich meiner Klasse Fächer hinzu?",
      content:
          '''Man kann seiner Klasse entweder Fächer hinzufügen, indem man unter Fächer/+/Fach erstellen ein Fach erstellt und unter Connect den Punkt Zur Klasse hinzufügen auswählt.
Oder man geht unter Bibliothek/[Klassenname]/Fächer auf Kurs hinzufügen und erstellt dort ein Fach. Wenn man bereits außerhalb der Klasse fächer erstellt hat, kann man diese auch mithilfe des Punktes Aus bestehenden Kursen hinzufügen, hinzufügen, indem man bei dem jeweiligen Fach auf das + drückt.
''',
    ),
    FAQ_Entry(
      title: "Wie kann man (Wahlpflicht-)Kurse eintragen?",
      content:
          "Kurse kann man nicht einfach eintragen. Um Kurse zu nutzen, geht man unter Bibliothek/[Klassenname]/Fächer und drückt neben dem Fach, indem man keinen Untericht hat, auf die drei Punkte. Dort muss man dann den Punkt Für mich deaktivieren auswählen. Danach wird einem persönlich das Fach nicht mehr im Stundenplan angezeigt und auch Hausaufgaben, etc. werden einem von dem entsprechenden Fach nicht mehr angezeigt. ",
    ),
  ];
}

List<FAQ_Entry> getFAQ_English() {
  return [
    FAQ_Entry(
      title:
          "How to change the number of short names displayed in the timeline?",
      content:
          "Go to Settings/Configure/General.  There you can choose between 1-4 letters displayed.",
    ),
    FAQ_Entry(
      title: "How do I create a class?",
      content:
          '''To create a class, you have to go to Library and press under the item "class" on Create.  Then you can then think about the name and an abbreviation for your class. You can also adjust the color of your class.''',
    ),
    FAQ_Entry(
      title: "How do I join a class?",
      content:
          "You can easily join a class by clicking on Library, and then clicking Join under School Class. There you have to enter the public code of your class, which you can get for example  from the class admin.",
    ),
    FAQ_Entry(
      title: "Can I have several planners at the same time?",
      content:
          "Yes.  You can create more plans by pressing Planner under Settings/Manage Planner.  Then you can switch back and forth between the old and the newly created plan. Alternatively, you can press on the name of the plan at the top of the bar and select the plan there.",
    ),
    FAQ_Entry(
      title: "Can I be in several classes?",
      content:
          "Yes.  But this is only possible by creating a further plan under Settings/Manage Planner. If you then select this, you can also join another class.",
    ),
    FAQ_Entry(
      title: "How can I display the times in the timetable?",
      content:
          "You have to go to Settings/Lessons and then to Time-based timetable.",
    ),
    FAQ_Entry(
      title: "The lesson times are not correct.  How can I change that?",
      content: "You have to go to Settings/Lessons/Times of lessons.",
    ),
    FAQ_Entry(
      title: "How can I set the count of daily school lessons?",
      content: "You have to go to Settings/Lessons/Amount of Lessons.",
    ),
    FAQ_Entry(
      title: "How can I adjust 12-/AB-weeks?",
      content:
          "You have to go under Settings/Lessons.  There you have to go to Multiple Weektypes.  There you can choose between 2-4 different weekly types.",
    ),
    FAQ_Entry(
      title: "How can I set Vacations for Timetable?",
      content:
          "Holidays vary depending on the state. You can select the vacations of your province under Settings/Vacations by pressing on vacationdatabase and selecting your appropriate state.  Currently only Germany and Austria are supported.",
    ),
    FAQ_Entry(
      title: "Nothing is displayed in the widget. Why?  (Android)",
      content:
          "To show something in the widget you have to go to Settings/Widgets and press Refresh Data. This has to be done every time something changes on the timetable.",
    ),
    FAQ_Entry(
      title:
          "How can I access the timetable, etc. from other devices besides Android / IOS?",
      content: "The function is not yet supported.  It will be added soon.",
    ),
    FAQ_Entry(
      title:
          "What means under Settings Go to Profile/Edit the point profile picture (URL)?",
      content:
          "Here you can enter the Internet link to a picture, which is then used as your profile picture.  Gallery images are currently not supported.",
    ),
    FAQ_Entry(
      title: "Can you enter timetable changes?",
      content:
          "Yes, by either pressing on the affected subject and then on the +, or by clicking on Info at Create quickly. Currently changes of location and teachers can be made. And you can enter Out lessons.",
    ),
    FAQ_Entry(
      title: "Is it possible to enter homework?",
      content:
          "Yes.  Go on Task at Create quickly, or to Library/Tasks and then on Task.",
    ),
    FAQ_Entry(
      title: "Is it possible to enter exams?",
      content:
          "Yes.  To do this, go to Library/Exams on Exam, or under Event at Create quickly and select under Eventype Exam.",
    ),
    FAQ_Entry(
      title: "Can I enter absences? ",
      content:
          "Yes, you have to go to Absenttime at Create quickly, or to Library/Absenttimes/New Absenttime.",
    ),
    FAQ_Entry(
      title: "How to create a course?",
      content:
          '''When you are in a class, it is usually not necessary to create your own course.  
Before you can create a course, you have to enter under library/Teachers, the teachers you have lessons with, and under library/Places, the places where you have lessons.  Alternatively, this is also possible while the course creation.  
To create a course, you have to press under Courses on the +. There you can choose between create a course completely yourself, use a template or join a course.  If you want to join a course, you need the public code of the course.
''',
    ),
    FAQ_Entry(
      title: "How do I add courses to my class?",
      content:
          '''You can either add courses to your class by creating a course under Courses/+/ Create Course and selecting Add to class at Connect.  Or go to Library/[Class Name]/Courses on Add Course and create a course there. 
 If you have already created courses outside of the class, you also can add them to your class. You have to go to Library/[Class Name]/Add Course/From existing Courses and press on the + next to the course you want to add.
''',
    ),
    FAQ_Entry(
      title: "How to create (elective) courses?",
      content: '''
Courses are not easy to enter.  To use courses, go to library/[Class Name]/Courses and press on the three points next to the lesson you don’t have. There you have to select the option Deactivate for me.  After that, the subject is no longer displayed in the timetable and also homework, etc. are no longer displayed to the deactivated course. ''',
    ),
  ];
}

class FAQ_ListView extends StatelessWidget {
  List<FAQ_Entry> getEntryList(BuildContext context) {
    switch (getString(context).languagecode) {
      case "de":
        return getFAQ_German();
      case "en":
        return getFAQ_English();
      default:
        return getFAQ_English();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: getEntryList(context)
          .map((entry) => ListTile(
                leading: entry.icon != null ? Icon(entry.icon) : null,
                title: Text(entry.title),
                onTap: () {
                  pushWidget(
                      context,
                      FAQ_DetailPage(
                        entry: entry,
                      ));
                },
              ))
          .toList(),
    );
  }
}

class FAQ_DetailPage extends StatelessWidget {
  final FAQ_Entry entry;

  const FAQ_DetailPage({this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: entry.title,
      ),
      backgroundColor: getBackgroundColor(context),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            color: getSheetColor(context),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                entry.content,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          ),
          FormDivider(),
        ],
      )),
    );
  }
}
