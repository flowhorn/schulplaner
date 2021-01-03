import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/holidays/edit_holiday_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/holidays/holiday_details_page.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class HolidayList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;

  HolidayList({
    @required this.plannerDatabase,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Map<String, Holiday>>(
        stream: plannerDatabase.vacations.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Holiday> vacationlist = snapshot.data.values.toList();
            vacationlist.sort((h1, h2) {
              return h1.start.toDateString.compareTo(h2.end.toDateString);
            });
            return UpListView(
              items: vacationlist,
              builder: (context, holiday) {
                if (holiday == null ||
                    holiday.start == null ||
                    holiday.name == null) {
                  return CircularProgressIndicator();
                }
                return HolidayTile(
                  holiday: holiday,
                  database: plannerDatabase,
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(
              context,
              NewHolidayPage(
                database: plannerDatabase,
              ));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newvacation),
      ),
    );
  }
}

class HolidayTile extends StatelessWidget {
  final Holiday holiday;
  final PlannerDatabase database;

  const HolidayTile({Key key, this.holiday, this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ColoredCircleIcon(
        icon: Icon(Icons.wb_sunny),
      ),
      title: Text(holiday.name.text),
      subtitle: holiday.start == holiday.end
          ? Column(
              children: <Widget>[
                Text(
                  (holiday.start != null
                      ? holiday.start.parser.toYMMMMEEEEd
                      : '-'),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
          : Column(
              children: <Widget>[
                Text(
                  getString(context).start +
                      ': ' +
                      (holiday.start != null
                          ? holiday.start.parser.toYMMMMEEEEd
                          : '-'),
                ),
                Text(
                  getString(context).end +
                      ': ' +
                      (holiday.end != null
                          ? holiday.end.parser.toYMMMMEEEEd
                          : '-'),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
      isThreeLine: holiday.start != holiday.end,
      onTap: () {
        showVacationDetail(
            context: context, plannerdatabase: database, holidayID: holiday.id);
      },
    );
  }
}
