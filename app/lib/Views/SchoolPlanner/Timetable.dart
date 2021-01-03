import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner8/teachers/teacher_detail_sheet.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Places.dart';
import 'package:schulplaner8/Views/SchoolPlanner/TimetableFragment.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessoninfo/edit_lesson_info_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessons/edit_lesson_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

ThemeData getLessonTheme(
    BuildContext context, Lesson lesson, PlannerDatabase database) {
  if (lesson.courseid != null) {
    return newAppThemeDesign(
        context, database.courseinfo.data[lesson.courseid].design);
  } else {
    return clearAppThemeData(context: context);
  }
}

class TimetableView extends StatelessWidget {
  final Color backgroundcolor;
  TimetableView({this.backgroundcolor});
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    return StreamBuilder<Map<String, Lesson>>(
      stream: plannerDatabase.getLessonsStream(),
      initialData: plannerDatabase.getLessons(),
      builder: (context, snapshot) {
        return DefaultTabController(
            length: plannerDatabase.settings.data.getAmountWeekTypes(),
            child: Scaffold(
              appBar: plannerDatabase.settings.data.multiple_weektypes
                  ? PreferredSize(
                      child: TabBar(
                        tabs: getListOfWeekTypes(
                                context, plannerDatabase.settings.data,
                                includealways: false)
                            .map((WeekType weektype) {
                          return Tab(
                            text: weektype.name,
                          );
                        }).toList(),
                        indicatorColor: getAccentColor(context),
                        labelColor: getClearTextColor(context),
                        unselectedLabelColor: getDividerColor(context),
                        indicatorWeight: 3.0,
                      ),
                      preferredSize:
                          Size(100.0, MediaQuery.of(context).size.width),
                    )
                  : PreferredSize(
                      child: Container(),
                      preferredSize: Size(0.0, 0.0),
                    ),
              body: TabBarView(
                  children: getTimetableFragments(
                      plannerDatabase, context, snapshot.data)),
              backgroundColor: backgroundcolor,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  pushWidget(
                      context,
                      NewLessonView(
                        database: plannerDatabase,
                      ));
                },
                child: Icon(Icons.add),
              ),
            ));
      },
    );
  }

  List<Widget> getTimetableFragments(PlannerDatabase plannerDatabase,
      BuildContext context, Map<String, Lesson> datamap) {
    List<Widget> mlist = [];
    PlannerSettingsData settingsData = plannerDatabase.settings.data;

    TimetableFragment buildFragment(int weektype) {
      if (settingsData.timetable_timemode) {
        return TimetableFragment(
          onTapLesson: (lesson) {
            showLessonDetailSheet(context,
                lessonid: lesson.lessonid, plannerdatabase: plannerDatabase);
          },
          daysOfWeek: settingsData.getAmountDaysOfWeek(),
          events: buildElements(plannerDatabase, datamap, weektype, true),
          starttime_calendar: getPositionForTimeString(settingsData
                  ?.lessontimes[(settingsData.zero_lesson ? 0 : 1)]?.start ??
              '7:00'),
          endtime_calendar: getPositionForTimeString(
              settingsData?.lessontimes[settingsData.maxlessons]?.end ??
                  '18:30'),
          timemode: true,
          periods: buildPeriodElements(plannerDatabase, true),
          haszerolesson: settingsData.zero_lesson,
          lessonheight: 60.0 *
              getConfigurationData(context).timetablesettings.heightfactor,
        );
      } else {
        return TimetableFragment(
          onTapEmpty: (item) {
            int day = item.item;
            int lesson = item.item2;
            showFastLessonCreator(
                context, plannerDatabase, day, lesson, weektype);
          },
          onTapLesson: (lesson) {
            showLessonDetailSheet(context,
                lessonid: lesson.lessonid, plannerdatabase: plannerDatabase);
          },
          daysOfWeek: settingsData.getAmountDaysOfWeek(),
          events: buildElements(plannerDatabase, datamap, weektype, false),
          starttime_calendar: (settingsData.zero_lesson ? 0 : 1).toDouble(),
          endtime_calendar: (settingsData.maxlessons + 1).toDouble(),
          timemode: false,
          periods: buildPeriodElements(plannerDatabase, false),
          haszerolesson: settingsData.zero_lesson,
          lessonheight: 60.0 *
              getConfigurationData(context).timetablesettings.heightfactor,
        );
      }
    }

    if (settingsData.multiple_weektypes) {
      mlist.add(buildFragment(1));
      mlist.add(buildFragment(2));
      if (settingsData.weektypes_amount > 2) mlist.add(buildFragment(3));
      if (settingsData.weektypes_amount > 3) mlist.add(buildFragment(4));
    } else {
      mlist.add(buildFragment(0));
    }
    return mlist;
  }

  List<TimeTableElement> buildElements(PlannerDatabase plannerDatabase,
      Map<String, Lesson> datamap, int weektype, bool timemode) {
    if (datamap == null) return [];
    List<TimeTableElement> mylist = [];
    Map<int, LessonTime> lessontimes =
        plannerDatabase.settings.data.lessontimes;
    datamap.values.forEach((l) {
      if (l.correctWeektype(weektype)) {
        mylist.add(TimeTableElement(
          startpos: getStartPositionForFragment(l, lessontimes, timemode),
          endpos: getEndPositionForFragment(l, lessontimes, timemode),
          course: plannerDatabase.getCourseInfo(l.courseid),
          lesson: l,
        ));
      }
    });
    return mylist;
  }

  List<TimeTablePeriodElement> buildPeriodElements(
      PlannerDatabase plannerDatabase, bool timemode) {
    List<TimeTablePeriodElement> mylist = [];
    PlannerSettingsData settingsData = plannerDatabase.settings.data;
    Map<int, LessonTime> lessontimes = settingsData.lessontimes;
    if (timemode) {
      lessontimes.values.forEach((l) {
        mylist.add(TimeTablePeriodElement(
            startpos: getPositionForTimeString(l.start),
            endpos: getPositionForTimeString(l.end),
            lessonTime: l));
      });
    } else {
      buildIntList(settingsData.maxlessons,
              start: settingsData.zero_lesson ? 0 : 1)
          .forEach((period) {
        mylist.add(TimeTablePeriodElement(
            startpos: period.toDouble(),
            endpos: (period + 1).toDouble(),
            period: period));
      });
    }

    return mylist;
  }

  double getStartPositionForFragment(
      Lesson lesson, Map<int, LessonTime> lessontimes, bool timemode) {
    if (timemode) {
      var split_start = (lesson.overridentime != null
              ? lesson.overridentime.start
              : (lessontimes[lesson.start]?.start ?? '8:00'))
          .split(':');
      double inhours_start =
          int.parse(split_start[0]) + (int.parse(split_start[1]) / 60);
      return inhours_start;
    } else {
      return lesson.start.toDouble();
    }
  }

  double getPositionForTimeString(String timestring) {
    var splitted = (timestring ?? '0:00').split(':');
    double inhours_start =
        int.parse(splitted[0] ?? 0) + (int.parse(splitted[1]) / 60) ?? 0;
    return inhours_start;
  }

  double getEndPositionForFragment(
      Lesson lesson, Map<int, LessonTime> lessontimes, bool timemode) {
    if (timemode) {
      var split_end = (lesson.overridentime != null
              ? lesson.overridentime.end
              : (lessontimes[lesson.end]?.end ?? '9:00'))
          .split(':');
      double inhours_end =
          int.parse(split_end[0]) + (int.parse(split_end[1]) / 60);
      return inhours_end;
    } else {
      return (lesson.end + 1).toDouble();
    }
  }
}

String getLessonTitle(BuildContext context, Lesson lesson) {
  String day = getWeekDays(context)[lesson.day].name;
  String periodtext = lesson.isMultiLesson()
      ? (lesson.start.toString() +
          '. -' +
          lesson.end.toString() +
          '. ' +
          getString(context).lesson)
      : (lesson.start.toString() +
          bothlang(context, en: '. lesson', de: '. Stunde'));
  String weektypetext = lesson.weektype != 0
      ? (' (' +
          (weektypes(context)[lesson.weektype].name.substring(0, 1)) +
          ')')
      : '';
  return day + ', ' + periodtext + weektypetext;
}

String getLessonPeriodString(
    BuildContext context, Lesson lesson, PlannerDatabase database) {
  if (lesson.overridentime != null) {
    return lesson.overridentime.start + ':' + lesson.overridentime.end;
  }
  Map<int, LessonTime> lessontimes = database.settings.data.lessontimes;
  String start_first = lessontimes[lesson.start]?.start;
  String end_last = lessontimes[lesson.end]?.end;
  return (start_first ?? '?') + '-' + (end_last ?? '?');
}

void showLessonDetailSheet(BuildContext context,
    {@required String lessonid,
    String datestring,
    @required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<Lesson>(
            stream: plannerdatabase.getLessonStream(lessonid),
            builder: (context, snapshot) {
              Lesson lesson = snapshot.data;
              if (lesson == null) return loadedView();
              Course courseInfo =
                  plannerdatabase.getCourseInfo(lesson.courseid);
              return Expanded(
                  child: Column(
                children: <Widget>[
                  getSheetText(context, getLessonTitle(context, lesson) ?? '-'),
                  getExpandList([
                    datestring == null
                        ? nowidget()
                        : Card(
                            child: StreamBuilder(
                              builder: (context, snapshot) {
                                Map<String, LessonInfo> datamap =
                                    snapshot.data ?? {};
                                List<LessonInfo> infolist =
                                    datamap.values.where((it) {
                                  if (it.date != datestring) return false;
                                  if (it.lessonid != lesson.lessonid) {
                                    return false;
                                  }
                                  return true;
                                }).toList();
                                if (infolist.isNotEmpty) {
                                  LessonInfo mInfo = infolist[0];
                                  return ListTile(
                                    title: Text(getLessonInfoTypes(
                                                context)[mInfo.type.index]
                                            .name +
                                        ': ' +
                                        getDateStringSmall(datestring)),
                                    leading: Icon(
                                      getLessonInfoTypes(
                                              context)[mInfo.type.index]
                                          .iconData,
                                      color: getLessonInfoColor(mInfo.type),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.mode_edit,
                                        ),
                                        onPressed: () {
                                          pushWidget(
                                              context,
                                              NewLessonInfoView(
                                                plannerdatabase,
                                                courseid: lesson.courseid,
                                                editmode: true,
                                                lessonid: lesson.lessonid,
                                                lessoninfoid: mInfo.id,
                                              ));
                                        }),
                                    subtitle: Column(
                                      children: <Widget>[
                                        mInfo.type == LessonInfoType.CHANGED
                                            ? Text(getString(context).teacher +
                                                ': ' +
                                                (mInfo.teacher?.name ?? '-') +
                                                ', ' +
                                                getString(context).place +
                                                ': ' +
                                                (mInfo.place?.name ?? '-'))
                                            : nowidget(),
                                        mInfo.note != null
                                            ? Text(getString(context).note +
                                                ': ' +
                                                mInfo.note)
                                            : nowidget()
                                      ],
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                    isThreeLine:
                                        mInfo.type == LessonInfoType.CHANGED
                                            ? (mInfo.note != null)
                                            : false,
                                  );
                                } else {
                                  return ListTile(
                                    title: Text(
                                        getString(context).nolessoninfos +
                                            ': ' +
                                            getDateStringSmall(datestring)),
                                    trailing: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          pushWidget(
                                              context,
                                              NewLessonInfoView(
                                                plannerdatabase,
                                                courseid: lesson.courseid,
                                                lessonid: lessonid,
                                                datestring: datestring,
                                              ));
                                        }),
                                  );
                                }
                              },
                              stream: plannerdatabase.lessoninfos.stream,
                            ),
                          ),
                    ListTile(
                      leading: Icon(Icons.widgets),
                      title: Text(courseInfo.getName()),
                    ),
                    ListTile(
                      leading: Icon(Icons.hourglass_empty),
                      title: Text(getLessonPeriodString(
                          context, lesson, plannerdatabase)),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(lesson.teacher?.name ??
                          courseInfo.getTeacherFirst() ??
                          '-'),
                      onTap: () {
                        String teacherid = lesson.teacher?.teacherid ??
                            courseInfo.getTeacherFirstItem()?.teacherid;
                        if (teacherid != null) {
                          showTeacherDetail(
                              context: context,
                              plannerdatabase: plannerdatabase,
                              teacherid: teacherid);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.place),
                      title: Text(lesson.place?.name ??
                          courseInfo.getPlaceFirst() ??
                          '-'),
                      onTap: () {
                        String placeid = lesson.place?.placeid ??
                            courseInfo.getPlaceFirstItem()?.placeid;
                        if (placeid != null) {
                          showPlaceDetail(
                              context: context,
                              plannerdatabase: plannerdatabase,
                              placeid: placeid);
                        }
                      },
                    ),
                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: getString(context).more,
                            onTap: () {
                              showSheetBuilder(
                                  context: context,
                                  child: (context) {
                                    return getFlexList([
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text(getString(context).edit),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pushWidget(
                                              context,
                                              NewLessonView(
                                                database: plannerdatabase,
                                                editmode: true,
                                                editmode_lessonid:
                                                    lesson.lessonid,
                                              ));
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.delete_sweep,
                                          color: Colors.red,
                                        ),
                                        title: Text(getString(context).delete),
                                        onTap: () {
                                          showConfirmDialog(
                                            context: context,
                                            title: getString(context).delete,
                                          ).then((delete) {
                                            if (delete) {
                                              requestSimplePermission(
                                                      context: context,
                                                      database: plannerdatabase,
                                                      category:
                                                          PermissionAccessType
                                                              .creator,
                                                      id: lesson.courseid,
                                                      routname: 'lessonid')
                                                  .then((result) {
                                                if (result == true) {
                                                  plannerdatabase.dataManager
                                                      .DeleteLesson(lesson);
                                                }
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ]);
                                  },
                                  title: getString(context).more,
                                  routname: 'lessonid');
                            },
                            iconData: Icons.more_horiz),
                      ],
                    ),
                  ),
                  FormSpace(16.0),
                ],
                mainAxisSize: MainAxisSize.min,
              ));
            });
      },
      routname: 'lessonid');
}

void showFastLessonCreator(BuildContext context, PlannerDatabase database,
    int day, int lesson, int weektype) {
  selectCourse(context, database, null).then((newCourse) {
    if (newCourse != null) {
      requestSimplePermission(
              context: context,
              database: database,
              category: PermissionAccessType.creator,
              id: newCourse.id)
          .then((result) {
        if (result == true) {
          database.dataManager.CreateLesson(Lesson(
              courseid: newCourse.id,
              lessonid: database.dataManager
                  .getLessonRefCourse(newCourse.id)
                  .doc()
                  .id,
              day: day,
              start: lesson,
              end: lesson,
              weektype: weektype));
        }
      });
    }
  });
}

Map<String, T> singleToMap<T>(T item, String key) {
  if (item == null) return {};
  return {key: item};
}
