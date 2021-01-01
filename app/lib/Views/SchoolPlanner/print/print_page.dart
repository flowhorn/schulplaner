import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/print/print_timetable.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class PrintPage extends StatelessWidget {
  final PlannerDatabase database;

  const PrintPage({Key key, this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text(bothlang(context,
                en: "This is a beta product under development. It is not yet fully working or designed. Please keep this in mind.",
                de: "Dies ist ein Beta-Produkt in der Entwicklung. Es ist noch nicht fertig designed und vollständig funktionsfähig. Bitte beachte dies!")),
          ),
        ),
        ListTile(
          leading: ColoredCircleIcon(
            icon: Icon(Icons.today),
          ),
          title: Text(getString(context).timetable),
          onTap: () {
            _openTimetablePrint(context);
          },
        )
      ],
    );
  }

  void _openTimetablePrint(BuildContext context) {
    selectItem(
        context: context,
        items: [1, 2],
        builder: (context, value) {
          if (value == 1) {
            return ListTile(
              leading: Icon(Icons.share),
              title: Text(getString(context).share),
              onTap: () {
                Navigator.pop(context);
                PrintTimetable(database).shareTimetable();
              },
            );
          }
          if (value == 2) {
            return ListTile(
              leading: Icon(Icons.print),
              title: Text(bothlang(context, en: "Print", de: "Drucken")),
              onTap: () {
                Navigator.pop(context);
                PrintTimetable(database).printTimetable();
              },
            );
          }
          return Container();
        });
  }
}
