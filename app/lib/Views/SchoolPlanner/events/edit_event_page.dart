import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/SmartCalAPI.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/attachments/edit_attachments_view.dart';
import 'package:schulplaner8/Views/SchoolPlanner/common/edit_page.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

// ignore: must_be_immutable
class NewSchoolEventView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  bool changedValues = false;

  List<String> _nextlessons;
  List<RecommendedDate> recommendeddates;
  SchoolEvent data;
  ValueNotifier<SchoolEvent> notifier;
  ValueNotifier<bool> showtimeofday = ValueNotifier(false);
  ValueNotifier<bool> showenddate = ValueNotifier(false);

  NewSchoolEventView.Create(
      {@required this.database, int type = 0, String date, String courseid})
      : editmode = false {
    data = SchoolEvent(type: type, date: date, courseid: courseid);
    notifier = ValueNotifier(data);

    if (data.date == null && data.courseid != null) {
      _nextlessons = getNextLessons(database, data.courseid, count: 1);
      if (_nextlessons.isNotEmpty) {
        data.date = _nextlessons[0];
      }
    }
  }

  NewSchoolEventView.Edit({
    @required this.database,
    @required SchoolEvent eventData,
  }) : editmode = true {
    data = eventData.copy();
    notifier = ValueNotifier(data);
  }
  List<RecommendedDate> getRecommendedDatesSimple(BuildContext context) {
    return [
      RecommendedDate(text: getString(context).today, date: getDateToday()),
      RecommendedDate(
          text: getString(context).tomorrow, date: getDateTomorrow()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (recommendeddates == null) {
      recommendeddates = (_nextlessons ?? [])
          .map((date) =>
              RecommendedDate(date: date, text: getString(context).nextlesson))
          .toList()
            ..addAll(getRecommendedDatesSimple(null));
    }
    return WillPopScope(
        child: ValueListenableBuilder<SchoolEvent>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Theme(
                  data: getEventTheme(context),
                  child: Scaffold(
                    appBar: MyAppHeader(
                        title: editmode
                            ? getString(context).editevent
                            : getString(context).newevent),
                    body: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        FormSpace(12.0),
                        FormTextField(
                          text: data.title,
                          valueChanged: (newtext) {
                            data.title = newtext;
                            changedValues = true;
                          },
                          labeltext: getString(context).title,
                          maxLength: 52,
                          maxLengthEnforced: true,
                          maxLines: 1,
                        ),
                        FormSpace(12.0),
                        FormDivider(),
                        ListTile(
                          title: Text(getString(context).eventtype),
                          leading: data.type != null
                              ? Icon(
                                  eventtype_data(context)[data.type].iconData)
                              : Icon(Icons.warning),
                          subtitle: Text(data.type != null
                              ? eventtype_data(context)[data.type].name
                              : '-'),
                          onTap: () {
                            selectItem<EventTypeData>(
                                context: context,
                                items: eventtype_data(context).values.toList(),
                                builder: (context, item) {
                                  bool isSelected = item.id == data.type;
                                  return ListTile(
                                    leading: Icon(item.iconData),
                                    title: Text(item.name),
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          )
                                        : null,
                                    enabled: !isSelected,
                                    onTap: () {
                                      Navigator.pop(context);
                                      data.type = item.id;
                                      notifier.value = data;
                                      notifier.notifyListeners();
                                    },
                                  );
                                });
                          },
                        ),
                        FormDivider(),
                        EditCourseField(
                          courseID: data.courseid,
                          database: database,
                          editmode: editmode,
                          onChanged: (context, newCourse) {
                            data.courseid = newCourse.id;
                            data.classid = null;
                            notifier.value = data;
                            List<String> nextlessons = getNextLessons(
                                database, data.courseid,
                                count: 1);
                            if (data.date == null && nextlessons.isNotEmpty) {
                              data.date = nextlessons[0];
                            }
                            recommendeddates = nextlessons
                                .map((date) => RecommendedDate(
                                    date: date,
                                    text: getString(context).nextlesson))
                                .toList()
                                  ..addAll(getRecommendedDatesSimple(context));
                            notifier.notifyListeners();
                          },
                        ),
                        SwitchListTile(
                          title: Text(getString(context).saveprivately),
                          value: data.private ?? false,
                          onChanged: editmode
                              ? null
                              : (newvalue) {
                                  data.private = newvalue;
                                  notifier.value = data;
                                  notifier.notifyListeners();
                                },
                        ),
                        FormDivider(),
                        ListTile(
                          leading: Icon(Icons.event),
                          title: Text(getString(context).date),
                          subtitle: Text(
                              data.date != null ? getDateText(data.date) : '-'),
                          onTap: () {
                            selectDateString(context, data.date)
                                .then((newDateString) {
                              if (newDateString != null) {
                                data.date = newDateString;
                                notifier.value = data;
                                notifier.notifyListeners();
                              }
                            });
                          },
                          trailing: IconButton(
                              icon: Icon(showenddate.value
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                              onPressed: () {
                                showenddate.value = !(showenddate.value);
                                notifier.notifyListeners();
                              }),
                        ),
                        showenddate.value
                            ? ListTile(
                                leading: Icon(Icons.date_range),
                                title: Text(getString(context).end),
                                subtitle: Text(data.enddate != null
                                    ? getDateText(data.enddate)
                                    : '-'),
                                onTap: () {
                                  selectDateString(context, data.enddate)
                                      .then((newDateString) {
                                    if (newDateString != null) {
                                      data.enddate = newDateString;
                                      notifier.value = data;
                                      notifier.notifyListeners();
                                    }
                                  });
                                },
                              )
                            : nowidget(),
                        SingleChildScrollView(
                          child: ButtonBar(
                            children: (recommendeddates ??
                                    getRecommendedDatesSimple(context))
                                .map((rec) {
                              return RButton(
                                  text: rec.text,
                                  onTap: () {
                                    data.date = rec.date;
                                    notifier.value = data;
                                    notifier.notifyListeners();
                                  },
                                  enabled: rec.date != data.date,
                                  disabledColor: Colors.green,
                                  iconData: rec.date == data.date
                                      ? Icons.done
                                      : null);
                            }).toList(),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                        FormDivider(),
                        FormHideable(
                            title: getString(context).timeofday,
                            notifier: showtimeofday,
                            builder: (context) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(getString(context).starttime),
                                    subtitle: Text(data.starttime ?? '-'),
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: parseTimeOfDay(
                                                  data.starttime))
                                          .then((TimeOfDay newtime) {
                                        if (newtime != null) {
                                          data.starttime =
                                              parseTimeString(newtime);
                                          notifier.notifyListeners();
                                        }
                                      });
                                    },
                                  ),
                                  ListTile(
                                    title: Text(getString(context).endtime),
                                    subtitle: Text(data.endtime ?? '-'),
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime:
                                                  parseTimeOfDay(data.endtime))
                                          .then((TimeOfDay newtime) {
                                        if (newtime != null) {
                                          data.endtime =
                                              parseTimeString(newtime);
                                          notifier.notifyListeners();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                        FormDivider(),
                        FormHeader(getString(context).more),
                        FormTextField(
                          text: data.detail,
                          valueChanged: (newtext) {
                            data.detail = newtext;
                            changedValues = true;
                          },
                          labeltext: getString(context).detail,
                        ),
                        FormSpace(16.0),
                        FormDivider(),
                        EditAttachementsView(
                          database: database,
                          attachments: data.files,
                          onAdded: (file) {
                            if (data.files == null) data.files = {};
                            data.files[file.fileid] = file;
                            notifier.notifyListeners();
                          },
                          onRemoved: (file) {
                            if (data.files == null) data.files = {};
                            data.files[file.fileid] = null;
                            notifier.notifyListeners();
                          },
                        ),
                        FormDivider(),
                        FormSpace(64.0),
                      ],
                    )),
                    floatingActionButton: FloatingActionButton.extended(
                        onPressed: () {
                          if ((editmode && data.validate()) ||
                              (editmode == false && data.validateCreate())) {
                            requestPermission().then((result) {
                              if (result) {
                                if (editmode) {
                                  database.dataManager.ModifySchoolEvent(data);
                                } else {
                                  database.dataManager.CreateSchoolEvent(data);
                                }
                                Navigator.pop(context);
                              } else {
                                var sheet =
                                    showPermissionStateSheet(context: context);
                                sheet.value = false;
                              }
                            });
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
                  ));
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

  ThemeData getEventTheme(BuildContext context) {
    if (data.courseid != null) {
      return newAppThemeDesign(
          context, database.courseinfo.data[data.courseid].getDesign());
    } else {
      if (data.classid != null) {
        return newAppThemeDesign(
            context, database.schoolClassInfos.data[data.classid].getDesign());
      } else {
        return clearAppThemeData(context: context);
      }
    }
  }

  Future<bool> requestPermission() {
    if (data.private == true) {
      return Future.value(true);
    } else {
      if (data.courseid != null) {
        return requestPermissionCourse(
            database: database,
            category: PermissionAccessType.creator,
            courseid: data.courseid);
      } else {
        if (data.classid != null) {
          return requestPermissionClass(
              database: database,
              category: PermissionAccessType.creator,
              classid: data.classid);
        } else {
          throw Exception('SOMETHING WENT WRONG???');
        }
      }
    }
  }
}
