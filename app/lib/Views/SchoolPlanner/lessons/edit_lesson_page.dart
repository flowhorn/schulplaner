//
import 'package:flutter/material.dart';
import 'package:schulplaner8/groups/src/models/place_link.dart';
import 'package:schulplaner8/groups/src/models/teacher_link.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner_addons/common/widgets/editpage.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/common/edit_page.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

// ignore: must_be_immutable
class NewLessonView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  String? editmode_lessonid;
  bool changedValues = false;

  bool showlongerlessons = false;

  late ValueNotifier<bool> showTeacherAndPlace;
  late ValueNotifier<bool> showOverrideTimes;

  late Lesson data;
  late ValueNotifier<Lesson> notifier;
  NewLessonView({
    required this.database,
    this.editmode = false,
    this.editmode_lessonid,
  }) {
    if (editmode) {
      data = database.getLessons()[editmode_lessonid]!.copy();
      if (data.isMultiLesson()) {
        showlongerlessons = true;
      }
    } else {
      data = Lesson(
        day: 1,
        start: 1,
        end: 1,
      );
    }
    notifier = ValueNotifier(data);

    showTeacherAndPlace = ValueNotifier(false);
    showOverrideTimes = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<Lesson>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Theme(
                  data: getLessonTheme(context),
                  child: Scaffold(
                    appBar: MyAppHeader(
                        title: editmode
                            ? getString(context).editlesson
                            : getString(context).newlesson),
                    body: ListView(
                      children: <Widget>[
                        FormSpace(12.0),
                        EditCourseField(
                          courseId: data.courseid,
                          editmode: editmode,
                          onChanged: (context, newCourse) {
                            data.courseid = newCourse.id;
                            notifier.value = data;
                            notifier.notifyListeners();
                          },
                        ),
                        Divider(),
                        EditCustomField(
                          value: data.day != null
                              ? getWeekDays(context)[data.day]!.name
                              : null,
                          label: getString(context).weekday,
                          onClicked: (context) {
                            return selectItem<Weekday>(
                                context: context,
                                items: getListOfWeekDays(
                                    context, database.settings.data!),
                                builder: (context, item) {
                                  return ListTile(
                                    trailing: data.day == item.day
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          )
                                        : null,
                                    title: Text(item.name),
                                    onTap: () {
                                      Navigator.pop(context);
                                      data.day = item.day;
                                      notifier.notifyListeners();
                                    },
                                  );
                                });
                          },
                        ),
                        Divider(),
                        showlongerlessons
                            ? Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.hourglass_empty),
                                    title: Text(getString(context).start),
                                    subtitle: Text(data.start != null
                                        ? (data.start.toString() +
                                            '. ' +
                                            getString(context).lesson)
                                        : '-'),
                                    onTap: () {
                                      selectItem<int>(
                                          context: context,
                                          items: buildIntList(
                                              database
                                                  .settings.data!.maxlessons,
                                              start: database.settings.data!
                                                      .zero_lesson
                                                  ? 0
                                                  : 1),
                                          builder: (context, item) {
                                            return ListTile(
                                              title: Text(item.toString() +
                                                  '. ' +
                                                  getString(context).lesson),
                                              onTap: () {
                                                Navigator.pop(context);
                                                data.start = item;
                                                notifier.notifyListeners();
                                              },
                                              enabled: item != data.start,
                                              trailing: item == data.start
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
                                    leading: Icon(Icons.hourglass_full),
                                    title: Text(getString(context).end),
                                    subtitle: Text(data.end != null
                                        ? (data.end.toString() +
                                            '. ' +
                                            getString(context).lesson)
                                        : '-'),
                                    trailing: IconButton(
                                        icon: Icon(Icons.expand_less),
                                        onPressed: () {
                                          showlongerlessons = false;
                                          data.end = data.start;
                                          notifier.notifyListeners();
                                        }),
                                    onTap: () {
                                      selectItem<int>(
                                          context: context,
                                          items: buildIntList(
                                              database
                                                  .settings.data!.maxlessons,
                                              start: data.start ??
                                                  (database.settings.data!
                                                          .zero_lesson
                                                      ? 0
                                                      : 1)),
                                          builder: (context, item) {
                                            return ListTile(
                                              title: Text(item.toString() +
                                                  '. ' +
                                                  getString(context).lesson),
                                              onTap: () {
                                                Navigator.pop(context);
                                                data.end = item;
                                                notifier.notifyListeners();
                                              },
                                              trailing: item == data.start
                                                  ? Icon(
                                                      Icons.done,
                                                      color: Colors.green,
                                                    )
                                                  : null,
                                              enabled: item != data.start,
                                            );
                                          });
                                    },
                                  )
                                ],
                              )
                            : ListTile(
                                leading: Icon(Icons.hourglass_full),
                                title: Text(getString(context).lesson),
                                subtitle: Text(data.start != null
                                    ? (data.start.toString() +
                                        '. ' +
                                        getString(context).lesson)
                                    : '-'),
                                trailing: IconButton(
                                    icon: Icon(Icons.expand_more),
                                    onPressed: () {
                                      showlongerlessons = true;
                                      notifier.notifyListeners();
                                    }),
                                onTap: () {
                                  selectItem<int>(
                                      context: context,
                                      items: buildIntList(
                                          database.settings.data!.maxlessons,
                                          start: database
                                                  .settings.data!.zero_lesson
                                              ? 0
                                              : 1),
                                      builder: (context, item) {
                                        return ListTile(
                                          title: Text(item.toString() +
                                              '. ' +
                                              getString(context).lesson),
                                          onTap: () {
                                            Navigator.pop(context);
                                            data.start = item;
                                            data.end = item;
                                            notifier.notifyListeners();
                                          },
                                          enabled: item != data.start,
                                          trailing: item == data.start
                                              ? Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                )
                                              : null,
                                        );
                                      });
                                },
                              ),
                        database.settings.data!.multiple_weektypes == false
                            ? nowidget()
                            : ListTile(
                                leading: Icon(Icons.view_week),
                                title: Text(getString(context).weektype),
                                subtitle: Text(data.weektype != null
                                    ? weektypes(context)[data.weektype]!.name
                                    : '-'),
                                onTap: () {
                                  selectItem<WeekType>(
                                      context: context,
                                      items: getListOfWeekTypes(
                                          context, database.settings.data!,
                                          includealways: true),
                                      builder: (context, item) {
                                        return ListTile(
                                          title: Text(item.name),
                                          onTap: () {
                                            Navigator.pop(context);
                                            data.weektype = item.type;
                                            notifier.notifyListeners();
                                          },
                                          trailing: data.weektype == item.type
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
                        FormHideable(
                            title: getString(context).individual,
                            notifier: showTeacherAndPlace,
                            builder: (context) {
                              return Column(
                                children: <Widget>[
                                  EditCustomField(
                                    label: getString(context).teacher,
                                    iconData: Icons.person_outline,
                                    value: data.teacher?.name ??
                                        (data.courseid != null
                                            ? database
                                                .getCourseInfo(data.courseid!)
                                                ?.getTeacherFirst()
                                            : null),
                                    onClicked: (context) {
                                      return selectTeacher(
                                              context,
                                              database,
                                              singleToMap(data.teacher,
                                                  data.teacher!.teacherid))
                                          .then((newteacher) {
                                        if (newteacher != null) {
                                          data.teacher =
                                              TeacherLink.fromTeacher(
                                                  newteacher);
                                          notifier.notifyListeners();
                                        }
                                      });
                                    },
                                    onRemoved: data.teacher == null
                                        ? null
                                        : (context) {
                                            data.teacher = null;
                                            notifier.notifyListeners();
                                          },
                                  ),
                                  Divider(),
                                  EditCustomField(
                                    label: getString(context).place,
                                    iconData: Icons.place,
                                    value: data.place?.name ??
                                        (data.courseid != null
                                            ? database
                                                .getCourseInfo(data.courseid!)
                                                ?.getPlaceFirst()
                                            : null),
                                    onClicked: (context) {
                                      return selectPlace(
                                              context,
                                              database,
                                              singleToMap(data.place,
                                                  data.place!.placeid))
                                          .then((newplace) {
                                        if (newplace != null) {
                                          data.place =
                                              PlaceLink.fromPlace(newplace);
                                          notifier.notifyListeners();
                                        }
                                      });
                                    },
                                    onRemoved: data.place == null
                                        ? null
                                        : (context) {
                                            data.place = null;
                                            notifier.notifyListeners();
                                          },
                                  ),
                                ],
                              );
                            }),
                        FormDivider(),
                        FormHideable(
                            title: getString(context).overritetimes,
                            notifier: showOverrideTimes,
                            builder: (context) {
                              String? getStartTime() {
                                if (data.overridentime?.start != null) {
                                  return data.overridentime?.start;
                                } else {
                                  if (data.start != null) {
                                    LessonTime? lessontimestart = database
                                        .getSettings()
                                        .lessontimes[data.start];
                                    if (lessontimestart != null) {
                                      return lessontimestart.start;
                                    }
                                  }
                                  return null;
                                }
                              }

                              String? getEndTime() {
                                if (data.overridentime?.end != null) {
                                  return data.overridentime?.end;
                                } else {
                                  if (data.end != null) {
                                    LessonTime? lessontimeend = database
                                        .getSettings()
                                        .lessontimes[data.end];
                                    if (lessontimeend != null) {
                                      return lessontimeend.end;
                                    }
                                  }
                                  return null;
                                }
                              }

                              return Column(
                                children: <Widget>[
                                  EditTimeField(
                                    label: getString(context).start,
                                    onChanged: (newTime) {
                                      if (newTime != null) {
                                        if (data.overridentime != null) {
                                          data.overridentime?.start =
                                              parseTimeString(newTime);
                                        } else {
                                          data.overridentime = OverrridenTime(
                                              start: parseTimeString(newTime));
                                        }
                                        notifier.notifyListeners();
                                      }
                                    },
                                    timeOfDay: getStartTime() != null
                                        ? parseTimeOfDay(getStartTime())
                                        : null,
                                    onRemoved: data.overridentime?.start == null
                                        ? null
                                        : (context) {
                                            data.overridentime?.start = null;
                                            if (data.overridentime?.end ==
                                                null) {
                                              data.overridentime = null;
                                            }
                                            notifier.notifyListeners();
                                          },
                                  ),
                                  EditTimeField(
                                    label: getString(context).end,
                                    onChanged: (newTime) {
                                      if (newTime != null) {
                                        if (data.overridentime != null) {
                                          data.overridentime?.end =
                                              parseTimeString(newTime);
                                        } else {
                                          data.overridentime = OverrridenTime(
                                              end: parseTimeString(newTime));
                                        }
                                        notifier.notifyListeners();
                                      }
                                    },
                                    timeOfDay: getEndTime() != null
                                        ? parseTimeOfDay(getEndTime())
                                        : null,
                                    onRemoved: data.overridentime?.start == null
                                        ? null
                                        : (context) {
                                            data.overridentime?.start = null;
                                            if (data.overridentime?.end ==
                                                null) {
                                              data.overridentime = null;
                                            }
                                            notifier.notifyListeners();
                                          },
                                  ),
                                ],
                              );
                            }),
                        FormDivider(),
                        FormSpace(64.0),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton.extended(
                        onPressed: () {
                          if ((editmode && data.validate()) ||
                              (editmode == false && data.validateCreate())) {
                            requestPermission().then((result) {
                              if (result) {
                                if (editmode) {
                                  database.dataManager.ModifyLesson(data);
                                } else {
                                  database.dataManager.CreateLesson(data);
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

  ThemeData getLessonTheme(BuildContext context) {
    if (data.courseid != null) {
      return newAppThemeDesign(
          context, database.courseinfo.data[data.courseid]?.getDesign());
    } else {
      return clearAppThemeData(context: context);
    }
  }

  Future<bool> requestPermission() {
    if (data.courseid != null) {
      return requestPermissionCourse(
          database: database,
          category: PermissionAccessType.creator,
          courseid: data.courseid!);
    } else {
      throw Exception('SOMETHING WENT WRONG???');
    }
  }
}
