import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Views/SchoolPlanner/planner_settings/notification_settings.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/grades/models/grade_profile.dart';
import 'package:schulplaner8/grades/models/grade_type.dart';
import 'package:schulplaner8/grades/models/grade_type_item.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradeDetail.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/Views/SchoolPlanner/planner_settings/holiday_settings.dart';
import 'package:schulplaner8/Views/SchoolPlanner/planner_settings/select_region_page.dart';
import 'package:schulplaner8/app_widget/update_logic.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:universal_commons/platform_check.dart';

typedef List<Widget> SubSettingsBuilder(
    BuildContext context, PlannerSettingsData settings);

class PlannerSettings extends StatelessWidget {
  const PlannerSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.stars),
          title: Text(getString(context).grades),
          onTap: () {
            pushWidget(context, getSubSettingsGrades(context, plannerDatabase));
          },
        ),
        ListTile(
          leading: Icon(Icons.today),
          title: Text(getString(context).lessons),
          onTap: () {
            pushWidget(
                context, getSubSettingsLessons(context, plannerDatabase));
          },
        ),
        ListTile(
          leading: Icon(Icons.wb_sunny),
          title: Text(getString(context).vacations),
          onTap: () {
            pushWidget(
                context,
                HolidaySettings(
                  database: plannerDatabase,
                ));
          },
        ),
        ListTile(
          leading: Icon(Icons.notifications_active),
          title: Text(getString(context).notifications),
          onTap: () {
            pushWidget(context, getSubSettingsNotifications(context));
          },
        ),
        ListTile(
          leading: Icon(Icons.widgets),
          title: Text(getString(context).widgets),
          onTap: () {
            pushWidget(context, getSubSettingsWidget(context, plannerDatabase));
          },
          enabled: PlatformCheck.isAndroid,
        ),
        ListTile(
          leading: Icon(Icons.perm_device_information),
          title: Text(getString(context).advanced),
          onTap: () {
            pushWidget(
                context, getSubSettingsAdvanced(context, plannerDatabase));
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

Widget getSubSettingsLessons(BuildContext context, PlannerDatabase database) {
  return SubSettingsPlanner(
      title: getString(context).lessons,
      plannerDatabase: database,
      builder: (context, settings) {
        return [
          SwitchListTile(
            value: settings.timetable_timemode,
            onChanged: (newvalue) {
              PlannerSettingsData newdata = settings.copy();
              newdata.timetable_timemode = newvalue;
              _updateSettings(newdata, database);
            },
            title: Text(getString(context).timebasedtimetable),
          ),
          FormSpace(12.0),
          FormDivider(),
          SwitchListTile(
            value: settings.zero_lesson,
            onChanged: (newvalue) {
              PlannerSettingsData newdata = settings.copy();
              newdata.zero_lesson = newvalue;
              _updateSettings(newdata, database);
            },
            title: Text(getString(context).zerolesson),
          ),
          SwitchListTile(
            value: settings.saturday_enabled,
            onChanged: (newvalue) {
              PlannerSettingsData newdata = settings.copy();
              newdata.saturday_enabled = newvalue;
              _updateSettings(newdata, database);
            },
            title: Text(getString(context).saturday),
          ),
          SwitchListTile(
            value: settings.sunday_enabled,
            onChanged: (newvalue) {
              PlannerSettingsData newdata = settings.copy();
              newdata.sunday_enabled = newvalue;
              if (newvalue == true) newdata.saturday_enabled = newvalue;
              _updateSettings(newdata, database);
            },
            title: Text(getString(context).sunday),
          ),
          ListTile(
            title: Text(getString(context).amountoflessons),
            subtitle: Text(settings.maxlessons.toString() +
                " " +
                getString(context).lessonsperday),
            onTap: () {
              selectItem(
                  context: context,
                  items: buildIntList(24, start: 1),
                  builder: (context, item) {
                    return ListTile(
                      title: Text(
                          item.toString() + " " + getString(context).lessons),
                      trailing: selectedView(item == settings.maxlessons),
                      onTap: () {
                        PlannerSettingsData newdata = settings.copy();
                        newdata.maxlessons = item;
                        _updateSettings(newdata, database);
                        Navigator.pop(context);
                      },
                    );
                  });
            },
          ),
          ListTile(
            title: Text(getString(context).timesoflessons),
            onTap: () {
              pushWidget(
                  context,
                  LessonTimeSettings(
                    database: database,
                  ));
            },
          ),
          FormDivider(),
          FormHeader(getString(context).weektype +
              " (12/AB-)" +
              getString(context).weeks),
          SwitchListTile(
            value: settings.multiple_weektypes,
            onChanged: (newvalue) {
              PlannerSettingsData newdata = settings.copy();
              newdata.multiple_weektypes = newvalue;
              _updateSettings(newdata, database);
            },
            title: Text(getString(context).multipleweektypes),
          ),
          settings.multiple_weektypes == false
              ? nowidget()
              : ListTile(
                  title: Text(getString(context).amountofweektypes),
                  subtitle: Text(settings.weektypes_amount.toString() +
                      " ${getString(context).weektypes}" +
                      " (${weektypesamount_meaning(context)[settings.weektypes_amount]})"),
                  onTap: () {
                    selectItem(
                        context: context,
                        items: [2, 3, 4],
                        builder: (context, item) {
                          return ListTile(
                            title: Text(item.toString() +
                                " ${getString(context).weektypes}" +
                                " (${weektypesamount_meaning(context)[item]})"),
                            trailing: item == settings.weektypes_amount
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              PlannerSettingsData newdata = settings.copy();
                              newdata.weektypes_amount = item;
                              _updateSettings(newdata, database);
                            },
                          );
                        });
                  },
                ),
          settings.multiple_weektypes == false
              ? nowidget()
              : ListTile(
                  title: Text(getString(context).currentweektype),
                  subtitle: Text(getCurrentWeekTypeName(context, settings)),
                  onTap: () {
                    selectItem<WeekType>(
                        context: context,
                        items: getListOfWeekTypes(context, settings,
                            includealways: false),
                        builder: (context, item) {
                          return ListTile(
                            title: Text(item.name),
                            onTap: () {
                              Navigator.pop(context);
                              WeekTypeFixPoint newfixpoint = WeekTypeFixPoint(
                                  weektype: item.type, date: getDateToday());
                              PlannerSettingsData newdata = settings.copy();
                              newdata.weekTypeFixPoint = newfixpoint;
                              _updateSettings(newdata, database);
                            },
                            trailing: settings.getCurrentWeekType() == item.type
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : null,
                          );
                        });
                  },
                ),
          FormDivider(),
          FormSpace(64.0),
        ];
      });
}

Widget getSubSettingsGrades(BuildContext context, PlannerDatabase database) {
  return SubSettingsPlanner(
      title: getString(context).grades,
      plannerDatabase: database,
      builder: (context, settings) {
        return [
          ListTile(
            leading: Icon(Icons.import_contacts),
            title: Text(getString(context).gradesystem),
            subtitle:
                Text(settings.getCurrentGradePackage(context: context).name),
            onTap: () {
              selectItem<GradePackage>(
                  context: context,
                  items: getGradePackages(context),
                  builder: (context, item) {
                    return ListTile(
                      title: Text(item.name),
                      onTap: () {
                        PlannerSettingsData newdata = settings.copy();
                        newdata.gradepackageid = item.id;
                        _updateSettings(newdata, database);
                        Navigator.pop(context);
                      },
                      trailing: item.id == settings.gradepackageid
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : null,
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.gamepad),
            title: Text(getString(context).averagedisplay),
            subtitle:
                Text(settings.getCurrentAverageDisplay(context: context).name),
            onTap: () {
              List list = settings
                  .getCurrentGradePackage(context: context)
                  .averagedisplays;
              selectItem<AverageDisplay>(
                  context: context,
                  items: list,
                  builder: (context, item) {
                    int index = list.indexOf(item);
                    return ListTile(
                      title: Text(item.name),
                      onTap: () {
                        PlannerSettingsData newsettings = settings;
                        newsettings.average_display_id = index;
                        _updateSettings(newsettings, database);
                        Navigator.pop(context);
                      },
                      trailing: index == settings.average_display_id
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : null,
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.data_usage),
            title: Text(getString(context).gradeprofiles +
                " (" +
                getString(context).average +
                ")"),
            onTap: () {
              pushWidget(
                  context,
                  GradeProfileSettings(
                    database: database,
                  ));
            },
          ),
          settings.gradepackageid == 1
              ? ListTile(
                  leading: Icon(Icons.all_out),
                  title: Text(getString(context).use_tendencies),
                  subtitle: Text(getString(context).use_tendencies_desc),
                  trailing: Switch(
                      value: settings.weight_tendencies,
                      onChanged: (bool b) {
                        PlannerSettingsData item = settings;
                        item.weight_tendencies = b;
                        _updateSettings(item, database);
                        //"Wie in der Oberstufe, z.B. 2+ als 1,7 und 2- als 2,3. Falls ausgeschaltet, werden + und - nicht gewertet, heißt z.B. eine 3- wird als 3 gewertet."
                      }),
                  isThreeLine: true,
                )
              : nowidget(),
          FormDivider(),
          FormSpace(64.0),
        ];
      });
}

Widget getSubSettingsNotifications(BuildContext context) {
  FirebaseMessaging().requestNotificationPermissions();
  return NotificationSettingsSubPage();
}

Widget getSubSettingsWidget(BuildContext context, PlannerDatabase database) {
  final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
  return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).widgets + " (Android)",
      ),
      body: StreamBuilder<AppSettingsData>(
        stream: appSettingsBloc.appSettingsData,
        initialData: appSettingsBloc.currentValue,
        builder: (context, snapshot) {
          final settingsdata = snapshot.data;
          return Builder(builder: (context) {
            return Column(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.update),
                    title: Text(getString(context).refreshdata),
                    subtitle: Text(getString(context).refreshdata_desc),
                    onTap: () {
                      updateAppWidget(context, database);
                    }),
                FormDivider(),
                FormHeader(getString(context).options),
                SwitchListTile(
                  title: Text(getString(context).darkmode),
                  value: settingsdata.appwidgetsettings.darkmode,
                  onChanged: (newvalue) {
                    AppSettingsData newdata = settingsdata.copyWith(
                        appwidgetsettings: settingsdata.appwidgetsettings
                            .copyWith(darkmode: newvalue));
                    appSettingsBloc.setAppSettings(newdata);
                    updateAppWidget(context, database);
                  },
                ),
                FormDivider(),
                FormSpace(64.0),
              ],
            );
          });
        },
      ));
}

void updateAppWidget(BuildContext context, PlannerDatabase database) {
  final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
  try {
    UpdateAppWidgetLogic().update(database, appSettingsBloc);
  } on PlatformException catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(getString(context).failed),
      backgroundColor: Colors.red,
    ));
  } finally {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(getString(context).refreshed),
      backgroundColor: Colors.green,
    ));
  }
}

Widget getSubSettingsAdvanced(BuildContext context, PlannerDatabase database) {
  print(database.uid);
  return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).advanced,
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text("UID: " + database.uid),
            ),
            ListTile(
              title: Text("PLANNERID: " + database.plannerid),
            ),
            ButtonBar(
              children: <Widget>[
                RButton(
                    text: getString(context).addtoclipboard,
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: database.uid + "::" + database.plannerid));
                    },
                    iconData: Icons.content_copy),
              ],
            )
          ],
        );
      }));
}

class SubSettingsPlanner extends StatelessWidget {
  final String title;
  final SubSettingsBuilder builder;
  final PlannerDatabase plannerDatabase;

  const SubSettingsPlanner({
    @required this.title,
    @required this.plannerDatabase,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: title,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<PlannerSettingsData>(
            stream: plannerDatabase.settings.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: builder(context, snapshot.data),
                  mainAxisSize: MainAxisSize.min,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class SubSettingsPlannerFloating extends StatelessWidget {
  final SubSettingsBuilder builder;
  final PlannerDatabase plannerDatabase;

  const SubSettingsPlannerFloating({
    @required this.plannerDatabase,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<PlannerSettingsData>(
          stream: plannerDatabase.settings.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: builder(context, snapshot.data),
                mainAxisSize: MainAxisSize.min,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

void _updateSettings(PlannerSettingsData newdata, PlannerDatabase database) {
  database.settings.reference.set(
    newdata.toJson(),
    SetOptions(
      merge: true,
    ),
  );
}

class LessonTimeSettings extends StatelessWidget {
  final PlannerDatabase database;
  bool changedValues = false;
  Map<int, LessonTime> lessontimes;
  ValueNotifier<Map<int, LessonTime>> notifier;
  LessonTimeSettings({this.database}) {
    lessontimes = Map.from(database.settings.data.lessontimes ?? {});
    notifier = ValueNotifier(lessontimes);
  }

  @override
  Widget build(BuildContext context) {
    final PlannerSettingsData settings = database.settings.data;
    return WillPopScope(
        child: Scaffold(
          appBar: MyAppHeader(title: getString(context).timesoflessons),
          body: ValueListenableBuilder<Map<int, LessonTime>>(
              valueListenable: notifier,
              builder: (context, data, _) {
                return ListView(
                    children: buildIntList(24,
                            start: database.settings.data.zero_lesson ? 0 : 1)
                        .map((value) {
                  LessonTime time = data[value];
                  if (time == null) time = LessonTime();
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(value.toString() +
                                ". " +
                                getString(context).lesson),
                            subtitle: Column(
                              children: <Widget>[
                                Text(getString(context).from +
                                    ": " +
                                    (time.start ?? "-")),
                                Text(getString(context).until +
                                    ": " +
                                    (time.end ?? "-")),
                              ],
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            enabled: settings.maxlessons >= value,
                            isThreeLine: true,
                          ),
                          Row(
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: getTimeOfDay(time.start))
                                      .then((newtime) {
                                    if (newtime != null) {
                                      Map<int, LessonTime> newdata =
                                          Map.from(lessontimes);
                                      LessonTime currentTime =
                                          newdata[value]?.copy() ??
                                              LessonTime();
                                      currentTime.start =
                                          parseTimeString(newtime);
                                      newdata[value] = currentTime;
                                      notifier.value = newdata;
                                      lessontimes = notifier.value;
                                      changedValues = true;
                                    }
                                  });
                                },
                                icon: Icon(Icons.hourglass_empty),
                                label: Text(
                                  getString(context).setstart,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: getTimeOfDay(time.end))
                                        .then((newtime) {
                                      if (newtime != null) {
                                        Map<int, LessonTime> newdata =
                                            Map.from(lessontimes);
                                        LessonTime currentTime =
                                            newdata[value]?.copy() ??
                                                LessonTime();
                                        currentTime.end =
                                            parseTimeString(newtime);
                                        newdata[value] = currentTime;
                                        notifier.value = newdata;
                                        lessontimes = notifier.value;
                                        changedValues = true;
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.hourglass_full),
                                  label: Text(
                                    getString(context).setend,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                    softWrap: true,
                                  )),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList());
              }),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                PlannerSettingsData newdata = settings.copy();
                newdata.lessontimes = lessontimes;
                _updateSettings(newdata, database);
                Navigator.pop(context);
              },
              icon: Icon(Icons.done),
              label: Text(getString(context).done)),
        ),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(
                          text: getString(context).currentchangesnotsaved)))
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

class GradeProfileSettings extends StatelessWidget {
  final PlannerDatabase database;
  GradeProfileSettings({this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).gradeprofiles),
      body: StreamBuilder<PlannerSettingsData>(
        builder: (context, snapshot) {
          List<GradeProfile> gradeprofiles =
              snapshot.data.gradeprofiles.values.toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              GradeProfile profile = gradeprofiles[index];
              return Padding(
                padding: EdgeInsets.all(4.0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(profile.name),
                        trailing: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  pushWidget(
                                      context,
                                      EditGradeProfileSettings(
                                        database: database,
                                        gradeprofile: profile,
                                      ));
                                }),
                            IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: profile.profileid == "default"
                                    ? null
                                    : () {
                                        showConfirmDialog(
                                                context: context,
                                                title:
                                                    getString(context).delete)
                                            .then((result) {
                                          if (result == true) {
                                            PlannerSettingsData newdata =
                                                database.settings.data.copy();
                                            newdata.gradeprofiles[
                                                profile.profileid] = null;
                                            _updateSettings(newdata, database);
                                          }
                                        });
                                      }),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.line_weight),
                        title: Text(
                            "${getString(context).averageforschoolreport}: " +
                                profile.weight_totalaverage.toString()),
                      ),
                      ListTile(
                          leading: Icon(Icons.merge_type),
                          title: Text(
                            profile.averagebytype
                                ? getString(context).averagebytype
                                : getString(context).averageofallgrades,
                          )),
                    ],
                  ),
                ),
              );
            },
            itemCount: gradeprofiles.length,
          );
        },
        stream: database.settings.stream,
        initialData: database.settings.data,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            PlannerSettingsData newdata = database.settings.data.copy();
            String newprofileid = database.dataManager.generateCourseId();
            newdata.gradeprofiles[newprofileid] =
                GradeProfile.Create(newprofileid).copyWith(
              name: getString(context).newgradeprofile,
            );
            _updateSettings(newdata, database);
          },
          icon: Icon(Icons.add),
          label: Text(getString(context).newgradeprofile)),
    );
  }
}

class EditGradeProfileSettings extends StatelessWidget {
  final PlannerDatabase database;
  bool changedValues = false;
  GradeProfile gradeprofile;
  ValueNotifier<GradeProfile> notifier;

  ValueNotifier<bool> showWeight = ValueNotifier(false);

  EditGradeProfileSettings({this.database, this.gradeprofile}) {
    notifier = ValueNotifier(gradeprofile);
  }

  @override
  Widget build(BuildContext context) {
    final PlannerSettingsData settings = database.settings.data;
    return WillPopScope(
        child: Scaffold(
          appBar: MyAppHeader(title: getString(context).editgradeprofile),
          body: ValueListenableBuilder<GradeProfile>(
              valueListenable: notifier,
              builder: (context, _, _2) {
                print(gradeprofile.toJson());
                return getDefaultList([
                  FormSpace(8.0),
                  FormTextField(
                    text: gradeprofile.name ?? "",
                    valueChanged: (newtext) {
                      gradeprofile = gradeprofile.copyWith(name: newtext);
                    },
                  ),
                  FormSpace(8.0),
                  FormDivider(),
                  FormHideable(
                      title: getString(context).weight,
                      notifier: showWeight,
                      builder: (context) {
                        return FormTextField(
                          iconData: Icons.line_weight,
                          labeltext: getString(context).weight,
                          text: gradeprofile.weight_totalaverage.toString(),
                          valueChanged: (String s) {
                            try {
                              double possibledouble = double.parse(s);
                              gradeprofile = gradeprofile.copyWith(
                                  weight_totalaverage: possibledouble);
                            } catch (exception) {
                              //bool correct_double = false;
                            }
                          },
                          keyBoardType: TextInputType.numberWithOptions(),
                          maxLines: 1,
                        );
                      }),
                  FormDivider(),
                  FormHeader(getString(context).average),
                  SwitchListTile(
                    value: gradeprofile.averagebytype,
                    onChanged: (newvalue) {
                      gradeprofile =
                          gradeprofile.copyWith(averagebytype: newvalue);
                      notifier.value = gradeprofile;
                    },
                    title: Text(getString(context).averagebytype),
                  ),
                  gradeprofile.averagebytype == false
                      ? nowidget()
                      : Padding(
                          padding: EdgeInsets.all(8.0),
                          child: getTitleCard(
                              iconData: Icons.merge_type,
                              title: getString(context).types,
                              content: gradeprofile.types.values
                                  .where((it) => it != null)
                                  .map<Widget>((gradetypeitem) {
                                String inPercent() {
                                  double total = gradeprofile.types.values
                                      .where((it) => it != null)
                                      .map((item) => item.weight)
                                      .reduce((a, b) => a + b);
                                  return ((Decimal.parse(gradetypeitem.weight
                                                  .toString()) /
                                              Decimal.parse(total.toString())) *
                                          Decimal.fromInt(100))
                                      .toStringAsFixed(1);
                                }

                                return ListTile(
                                  leading: Text(
                                      gradetypeitem.weight.toString() +
                                          "\n(${inPercent()}%)"),
                                  title: Text(gradetypeitem.name ?? "-"),
                                  subtitle: Text(
                                    gradetypeitem.getGradeTypesListed(context),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  trailing: Row(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            pushWidget(
                                                context,
                                                EditGradeTypeItemSettings(
                                                  gradetypeitem: gradetypeitem,
                                                )).then((newdata) {
                                              if (newdata != null &&
                                                  newdata is GradeTypeItem) {
                                                gradeprofile =
                                                    gradeprofile.copyWith();
                                                gradeprofile.types[newdata.id] =
                                                    newdata;
                                                notifier.value = gradeprofile;
                                              }
                                            });
                                          }),
                                      IconButton(
                                          icon: Icon(Icons.delete_outline),
                                          onPressed: () {
                                            showConfirmDialog(
                                                    context: context,
                                                    title: getString(context)
                                                        .delete)
                                                .then((result) {
                                              if (result == true) {
                                                gradeprofile =
                                                    gradeprofile.copyWith();
                                                gradeprofile.types[
                                                    gradetypeitem.id] = null;
                                                notifier.value = gradeprofile;
                                              }
                                            });
                                          })
                                    ],
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                );
                              }).toList()
                                    ..add(FormButton(getString(context).newtype,
                                        () {
                                      String newid =
                                          gradeprofile.getNewTypeId();
                                      gradeprofile = gradeprofile.copyWith();
                                      gradeprofile.types[newid] =
                                          GradeTypeItem.Create(newid).copyWith(
                                              name: getString(context).newtype);
                                      notifier.value = gradeprofile;
                                      pushWidget(
                                          context,
                                          EditGradeTypeItemSettings(
                                            gradetypeitem:
                                                gradeprofile.types[newid],
                                          )).then((newdata) {
                                        if (newdata != null &&
                                            newdata is GradeTypeItem) {
                                          gradeprofile =
                                              gradeprofile.copyWith();
                                          gradeprofile.types[newdata.id] =
                                              newdata;
                                          notifier.value = gradeprofile;
                                        }
                                      });
                                    }))),
                        ),
                  FormDivider(),
                  FormSpace(64.0),
                ]);
              }),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                PlannerSettingsData newdata = settings.copy();
                newdata.gradeprofiles[gradeprofile.profileid] = gradeprofile;
                _updateSettings(newdata, database);
                Navigator.pop(context);
              },
              icon: Icon(Icons.done),
              label: Text(getString(context).done)),
        ),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(
                          text: getString(context).currentchangesnotsaved)))
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

class EditGradeTypeItemSettings extends StatelessWidget {
  bool changedValues = false;
  GradeTypeItem gradetypeitem;
  ValueNotifier<GradeTypeItem> notifier;

  ValueNotifier<bool> showWeight = ValueNotifier(true);
  ValueNotifier<bool> showextras = ValueNotifier(false);

  EditGradeTypeItemSettings({this.gradetypeitem}) {
    notifier = ValueNotifier(gradetypeitem);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: MyAppHeader(title: getString(context).type),
          body: ValueListenableBuilder<GradeTypeItem>(
              valueListenable: notifier,
              builder: (context, _, _2) {
                return getDefaultList([
                  FormSpace(8.0),
                  FormTextField(
                    text: gradetypeitem.name ?? "",
                    valueChanged: (newtext) {
                      gradetypeitem = gradetypeitem.copyWith(name: newtext);
                    },
                  ),
                  FormSpace(8.0),
                  FormDivider(),
                  FormHideable(
                      title: getString(context).weight,
                      notifier: showWeight,
                      builder: (context) {
                        return FormTextField(
                          iconData: Icons.line_weight,
                          labeltext: getString(context).weight,
                          text: gradetypeitem.weight.toString(),
                          valueChanged: (String s) {
                            try {
                              double possibledouble = double.parse(s);
                              gradetypeitem = gradetypeitem.copyWith(
                                  weight: possibledouble);
                              // bool correct_double = true;
                            } catch (exception) {
                              //bool correct_double = false;
                            }
                          },
                          keyBoardType: TextInputType.numberWithOptions(),
                          maxLines: 1,
                        );
                      }),
                  FormDivider(),
                  FormHeader(getString(context).gradetypes),
                  Column(
                    children: getGradeTypes(context).map((item) {
                      bool getCurrentValue() {
                        if (GradeType.values[item.id] == GradeType.TEST &&
                            gradetypeitem.testsasoneexam == true) return true;
                        return gradetypeitem
                                .gradetypes[GradeType.values[item.id]] ??
                            false;
                      }

                      return CheckboxListTile(
                        value: getCurrentValue(),
                        onChanged: (newvalue) {
                          gradetypeitem = gradetypeitem.copyWith();
                          gradetypeitem.gradetypes[GradeType.values[item.id]] =
                              newvalue;
                          notifier.value = gradetypeitem;
                        },
                        title: Text(item.name),
                      );
                    }).toList(),
                  ),
                  FormDivider(),
                  FormHideable(
                      title: getString(context).extras,
                      notifier: showextras,
                      builder: (context) {
                        return Column(
                          children: <Widget>[
                            SwitchListTile(
                              title: Text(getString(context).testsasoneexam),
                              value: gradetypeitem.testsasoneexam ?? false,
                              onChanged: (newvalue) {
                                gradetypeitem = gradetypeitem.copyWith(
                                    testsasoneexam: newvalue);
                                notifier.value = gradetypeitem;
                              },
                            ),
                          ],
                        );
                      }),
                  FormDivider(),
                  FormSpace(64.0),
                ]);
              }),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, gradetypeitem);
              },
              icon: Icon(Icons.done),
              label: Text(getString(context).done)),
        ),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
                  context: context,
                  title: getString(context).discardchanges,
                  action: getString(context).confirm,
                  richtext: RichText(
                      text: TextSpan(
                          text: getString(context).currentchangesnotsaved)))
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

class ShortPlannerSettings extends StatelessWidget {
  const ShortPlannerSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    return SubSettingsPlannerFloating(
        plannerDatabase: plannerDatabase,
        builder: (context, settings) {
          return [
            StreamBuilder(
              builder: (context, snapshot) {
                AppSettingsData appSettingsData = snapshot.data;
                return SwitchListTile(
                  value: appSettingsData.darkmode ?? false,
                  onChanged: (newvalue) {
                    appSettingsBloc.setAppSettings(
                        appSettingsData.copyWith(darkmode: newvalue));
                  },
                  title: Text(getString(context).darkmode),
                );
              },
              stream: appSettingsBloc.appSettingsData,
              initialData: appSettingsBloc.currentValue,
            ),
            SwitchListTile(
              value: settings.timetable_timemode,
              onChanged: (newvalue) {
                PlannerSettingsData newdata = settings.copy();
                newdata.timetable_timemode = newvalue;
                _updateSettings(newdata, plannerDatabase);
              },
              title: Text(getString(context).timebasedtimetable),
            ),
            FormSpace(12.0),
            FormDivider(),
            SwitchListTile(
              value: settings.zero_lesson,
              onChanged: (newvalue) {
                PlannerSettingsData newdata = settings.copy();
                newdata.zero_lesson = newvalue;
                _updateSettings(newdata, plannerDatabase);
              },
              title: Text(getString(context).zerolesson),
            ),
            SwitchListTile(
              value: settings.saturday_enabled,
              onChanged: (newvalue) {
                PlannerSettingsData newdata = settings.copy();
                newdata.saturday_enabled = newvalue;
                _updateSettings(newdata, plannerDatabase);
              },
              title: Text(getString(context).saturday),
            ),
            SwitchListTile(
              value: settings.sunday_enabled,
              onChanged: (newvalue) {
                PlannerSettingsData newdata = settings.copy();
                newdata.sunday_enabled = newvalue;
                if (newvalue == true) newdata.saturday_enabled = newvalue;
                _updateSettings(newdata, plannerDatabase);
              },
              title: Text(getString(context).sunday),
            ),
            ListTile(
              title: Text(getString(context).amountoflessons),
              subtitle: Text(settings.maxlessons.toString() +
                  " " +
                  getString(context).lessonsperday),
              onTap: () {
                selectItem(
                    context: context,
                    items: buildIntList(24, start: 1),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(
                            item.toString() + " " + getString(context).lessons),
                        trailing: selectedView(item == settings.maxlessons),
                        onTap: () {
                          PlannerSettingsData newdata = settings.copy();
                          newdata.maxlessons = item;
                          _updateSettings(newdata, plannerDatabase);
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
            ListTile(
              title: Text(getString(context).timesoflessons),
              onTap: () {
                pushWidget(
                    context,
                    LessonTimeSettings(
                      database: plannerDatabase,
                    ));
              },
            ),
            FormDivider(),
            FormHeader(getString(context).weektype +
                " (12/AB-)" +
                getString(context).weeks),
            SwitchListTile(
              value: settings.multiple_weektypes,
              onChanged: (newvalue) {
                PlannerSettingsData newdata = settings.copy();
                newdata.multiple_weektypes = newvalue;
                _updateSettings(newdata, plannerDatabase);
              },
              title: Text(getString(context).multipleweektypes),
            ),
            settings.multiple_weektypes == false
                ? nowidget()
                : ListTile(
                    title: Text(getString(context).amountofweektypes),
                    subtitle: Text(settings.weektypes_amount.toString() +
                        " ${getString(context).weektypes}" +
                        " (${weektypesamount_meaning(context)[settings.weektypes_amount]})"),
                    onTap: () {
                      selectItem(
                          context: context,
                          items: [2, 3, 4],
                          builder: (context, item) {
                            return ListTile(
                              title: Text(item.toString() +
                                  " ${getString(context).weektypes}" +
                                  " (${weektypesamount_meaning(context)[item]})"),
                              trailing: item == settings.weektypes_amount
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : null,
                              onTap: () {
                                Navigator.pop(context);
                                PlannerSettingsData newdata = settings.copy();
                                newdata.weektypes_amount = item;
                                _updateSettings(newdata, plannerDatabase);
                              },
                            );
                          });
                    },
                  ),
            settings.multiple_weektypes == false
                ? nowidget()
                : ListTile(
                    title: Text(getString(context).currentweektype),
                    subtitle: Text(getCurrentWeekTypeName(context, settings)),
                    onTap: () {
                      selectItem<WeekType>(
                          context: context,
                          items: getListOfWeekTypes(context, settings,
                              includealways: false),
                          builder: (context, item) {
                            return ListTile(
                              title: Text(item.name),
                              onTap: () {
                                Navigator.pop(context);
                                WeekTypeFixPoint newfixpoint = WeekTypeFixPoint(
                                    weektype: item.type, date: getDateToday());
                                PlannerSettingsData newdata = settings.copy();
                                newdata.weekTypeFixPoint = newfixpoint;
                                _updateSettings(newdata, plannerDatabase);
                              },
                              trailing:
                                  settings.getCurrentWeekType() == item.type
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : null,
                            );
                          });
                    },
                  ),
            FormDivider(),
            FormHeader(getString(context).further),
            ListTile(
              title: Text(getString(context).vacationdatabase),
              subtitle: settings.vacationpackageid == null
                  ? Text(getString(context).nothingselected)
                  : RegionName(
                      regionID: settings.vacationpackageid,
                      holidayGateway: plannerDatabase.holidayGateway,
                    ),
              onTap: () {
                pushWidget(
                    context,
                    SelectRegionPage(
                      database: plannerDatabase,
                    ));
              },
              trailing: settings.vacationpackageid == null
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        PlannerSettingsData newdata = settings.copy();
                        newdata.vacationpackageid = null;
                        _updateSettings(newdata, plannerDatabase);
                      }),
            ),
            ListTile(
              leading: Icon(Icons.import_contacts),
              title: Text(getString(context).gradesystem),
              subtitle:
                  Text(settings.getCurrentGradePackage(context: context).name),
              onTap: () {
                selectItem<GradePackage>(
                    context: context,
                    items: getGradePackages(context),
                    builder: (context, item) {
                      return ListTile(
                        title: Text(item.name),
                        onTap: () {
                          PlannerSettingsData newdata = settings.copy();
                          newdata.gradepackageid = item.id;
                          _updateSettings(newdata, plannerDatabase);
                          Navigator.pop(context);
                        },
                        trailing: item.id == settings.gradepackageid
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                      );
                    });
              },
            ),
            //FormSpace(64.0),
          ];
        });
  }

  void _updateSettings(PlannerSettingsData newdata, PlannerDatabase database) {
    database.settings.reference.set(
      newdata.toJson(),
      SetOptions(
        merge: true,
      ),
    );
  }
}
