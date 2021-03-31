import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/holidays/edit_holiday_page.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/utils/models/id.dart';

Future<void> showVacationDetail({
  required BuildContext context,
  required ID holidayID,
}) async {
  final plannerDatabase = PlannerDatabaseBloc.getDatabase(context);
  await showDetailSheetBuilder(
    context: context,
    body: (BuildContext context) {
      return StreamBuilder<Holiday?>(
        stream: plannerDatabase.vacations.getItemStream(holidayID.key),
        builder: (BuildContext context, snapshot) {
          final item = snapshot.data;
          if (item == null) return loadedView();
          return Column(
            children: <Widget>[
              getSheetText(context, item.name.text),
              FormSpace(12.0),
              ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  getString(context).from +
                      ' ' +
                      item.start!.parser.toYMMMMEEEEd,
                ),
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text(
                  getString(context).until +
                      ' ' +
                      item.end!.parser.toYMMMMEEEEd,
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  RButton(
                    text: getString(context).more,
                    onTap: item.isFromDatabase
                        ? null
                        : () {
                            showSheetBuilder(
                              context: context,
                              child: (context) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text(getString(context).edit),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pushWidget(
                                          context,
                                          NewHolidayPage(
                                            database: plannerDatabase,
                                            editMode: true,
                                            editvacationid: item.id.key,
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete_outline),
                                      title: Text(getString(context).delete),
                                      onTap: () {
                                        showConfirmDialog(
                                                context: context,
                                                title:
                                                    getString(context).delete,
                                                action:
                                                    getString(context).delete,
                                                richtext: null)
                                            .then(
                                          (result) {
                                            if (result == true) {
                                              plannerDatabase.dataManager
                                                  .DeleteVacation(item);
                                              popNavigatorBy(
                                                context,
                                                text: 'vacationid',
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                              title: getString(context).more,
                              routname: 'vacationidmore',
                            );
                          },
                    iconData: Icons.more_horiz,
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
    routname: 'vacationidview',
  );
}
