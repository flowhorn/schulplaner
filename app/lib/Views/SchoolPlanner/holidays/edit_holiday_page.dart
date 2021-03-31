//
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/holiday_database/models/holiday_type.dart';
import 'package:date/date.dart';
import 'package:schulplaner8/utils/models/id.dart';
import 'package:schulplaner8/utils/models/name.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

// ignore: must_be_immutable
class NewHolidayPage extends StatelessWidget {
  final PlannerDatabase database;
  bool changedValues = false;
  final bool editMode;
  final String? editvacationid;

  late Holiday data;
  late ValueNotifier<Holiday> notifier;
  NewHolidayPage(
      {required this.database, this.editMode = false, this.editvacationid}) {
    data = editMode
        ? database.vacations.data[editvacationid]!.copyWith()
        : Holiday(
            id: ID(database.dataManager.generateVacationId()),
            name: Name(''),
            start: null,
            end: null,
            isFromDatabase: false,
            type: HolidayType.holiday,
          );
    notifier = ValueNotifier(data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<Holiday>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Scaffold(
                appBar: MyAppHeader(
                    title: editMode
                        ? getString(context).editvacation
                        : getString(context).newvacation),
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    FormHeader(getString(context).general),
                    FormTextField(
                      text: data.name.text,
                      valueChanged: (newtext) {
                        data = data.copyWith(name: Name(newtext));
                        changedValues = true;
                      },
                      labeltext: getString(context).name,
                    ),
                    FormSpace(16.0),
                    FormDivider(),
                    FormHeader(getString(context).timespan),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text(getString(context).start),
                      subtitle: Text(data.start != null
                          ? data.start!.parser.toYMMMMEEEEd
                          : '-'),
                      onTap: () {
                        selectDateString(context, data.start?.toDateString)
                            .then((newDateString) {
                          if (newDateString != null) {
                            data = data.copyWith(start: Date(newDateString));
                            notifier.value = data;
                          }
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text(getString(context).end),
                      subtitle: Text(data.end != null
                          ? data.end!.parser.toYMMMMEEEEd
                          : '-'),
                      onTap: () {
                        selectDateString(context, data.end?.toDateString)
                            .then((newDateString) {
                          if (newDateString != null) {
                            data = data.copyWith(end: Date(newDateString));
                            notifier.value = data;
                          }
                        });
                      },
                    ),
                    FormDivider(),
                    FormSpace(64.0),
                  ],
                )),
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      if (HolidayValidator.validate(data)) {
                        if (editMode) {
                          database.dataManager.ModifyVacation(data);
                          Navigator.pop(context);
                        } else {
                          database.dataManager.AddHoliday(data);
                          Navigator.pop(context);
                        }
                      } else {
                        final infoDialog = InfoDialog(
                          title: getString(context).failed,
                          message: getString(context).pleasecheckdata,
                        );
                        // ignore: unawaited_futures
                        infoDialog.show(context);
                      }
                    },
                    icon: Icon(Icons.done),
                    label: Text(getString(context).done)),
              );
            }),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(text: getString(context).pleasecheckdata)))
              .then((value) {
            if (value == true) {
              return true;
            } else {
              return false;
            }
          });
        });
  }
}
