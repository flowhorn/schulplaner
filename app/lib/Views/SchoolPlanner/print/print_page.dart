import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/print/print_timetable.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class PrintPage extends StatelessWidget {
  const PrintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text(bothlang(context,
                en: 'This feature is currently still in BETA, so some troubles may still occur!',
                de: 'Diese Funktion befindet sich zurzeit noch in der BETA, sodass noch einige Probleme auftreten können!')),
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
                PrintTimetable(PlannerDatabaseBloc.getDatabase(context))
                    .shareTimetable();
              },
            );
          }
          if (value == 2) {
            return ListTile(
              leading: Icon(Icons.print),
              title: Text(bothlang(context, en: 'Print', de: 'Drucken')),
              onTap: () {
                Navigator.pop(context);
                PrintTimetable(PlannerDatabaseBloc.getDatabase(context))
                    .printTimetable();
              },
            );
          }
          return Container();
        });
  }
}
