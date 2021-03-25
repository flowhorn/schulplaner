//
import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/grades/grade_details_list.dart';
import 'package:schulplaner8/groups/src/pages/course_list.dart';
import 'package:schulplaner8/groups/src/pages/join_group_page.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/SchoolReport.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/OldRest/CalendarView.dart';
import 'package:schulplaner8/OldRest/Timeline.dart';
import 'package:schulplaner8/Views/SchoolPlanner/FileHub.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyAbsentTime.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyEvents.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MySchoolClass.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Places.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Teachers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/holidays/holiday_list.dart';
import 'package:schulplaner8/Views/SchoolPlanner/print/print_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_page.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class ShortSchoolClassView extends StatelessWidget {
  const ShortSchoolClassView();

  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return StreamBuilder<Map<String, SchoolClass>>(
      builder: (context, snapshot) {
        Map<String, SchoolClass> data = snapshot.data ?? {};
        return Column(
          children: data.values.map<Widget>((classinfo) {
            return ListTile(
              leading: Hero(
                  tag: 'classtag:' + classinfo.id,
                  child: ColoredCircleText(
                      text: toShortNameLength(
                          context, classinfo.getShortname_full()),
                      color: classinfo.getDesign().primary,
                      radius: 22.0)),
              title: Text(classinfo.name ?? '-'),
              trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showSchoolClassMoreSheet(context,
                        classid: classinfo.id,
                        plannerdatabase: plannerDatabase);
                  }),
              onTap: () {
                pushWidget(
                    context,
                    SchoolClassView(
                      classid: classinfo.id,
                    ),
                    routname: 'schoolclass');
              },
            );
          }).toList()
            ..add(data.isNotEmpty
                ? FormSpace(0.0)
                : ButtonBar(
                    children: <Widget>[
                      RButton(
                          text: getString(context).create,
                          onTap: () {
                            pushWidget(
                                context,
                                NewSchoolClassView(
                                  database: plannerDatabase,
                                ));
                          },
                          iconData: Icons.add_circle_outline),
                      RButton(
                          text: getString(context).join,
                          onTap: () {
                            openGroupJoinPage(context: context);
                          },
                          iconData: Icons.link),
                    ],
                  )),
        );
      },
      stream: plannerDatabase.schoolClassInfos.stream,
      initialData: plannerDatabase.schoolClassInfos.data,
    );
  }
}

class LibraryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    final navigationBloc = NavigationBloc.of(context);
    return Container(
      color: getBackgroundColor(context),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormSection(
              title: getString(context).schoolclass,
              child: StreamBuilder<Map<String, SchoolClass>>(
                builder: (context, snapshot) {
                  Map<String, SchoolClass> data = snapshot.data ?? {};
                  return Column(
                    children: data.values.map<Widget>((classinfo) {
                      return ListTile(
                        leading: Hero(
                            tag: 'classtag:' + classinfo.id,
                            child: ColoredCircleText(
                                text: toShortNameLength(
                                    context, classinfo.getShortname_full()),
                                color: classinfo.getDesign().primary,
                                radius: 22.0)),
                        title: Text(classinfo.name ?? '-'),
                        trailing: IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              showSchoolClassMoreSheet(context,
                                  classid: classinfo.id,
                                  plannerdatabase: plannerDatabase);
                            }),
                        onTap: () {
                          pushWidget(
                              context,
                              SchoolClassView(
                                classid: classinfo.id,
                              ),
                              routname: 'schoolclass');
                        },
                      );
                    }).toList()
                      ..add(data.isNotEmpty
                          ? FormSpace(0.0)
                          : ButtonBar(
                              children: <Widget>[
                                RButton(
                                    text: getString(context).create,
                                    onTap: () {
                                      pushWidget(
                                          context,
                                          NewSchoolClassView(
                                            database: plannerDatabase,
                                          ));
                                    },
                                    iconData: Icons.add_circle_outline),
                                RButton(
                                    text: getString(context).join,
                                    onTap: () {
                                      openGroupJoinPage(context: context);
                                    },
                                    iconData: Icons.link),
                              ],
                            )),
                  );
                },
                stream: plannerDatabase.schoolClassInfos.stream,
                initialData: plannerDatabase.schoolClassInfos.data,
              ),
            ),
            FormSection(
              title: getString(context).events,
              child: Column(
                children: <Widget>[
                  getFunctionTile(context,
                      name: getString(context).allevents,
                      iconData: Icons.event_note, onTap: () {
                    navigationBloc.openSubChild(
                      'allevents',
                      MyEventsList(),
                      getString(context).allevents,
                      actions: (context) {
                        return [
                          IconButton(
                              icon: Icon(Icons.archive),
                              onPressed: () {
                                pushWidget(context, MyEventsArchive());
                              })
                        ];
                      },
                      navigationItem: NavigationItem.allEvents,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).tasks,
                      iconData: Icons.book, onTap: () {
                    navigationBloc.openSubChild(
                      'tasks',
                      MyTasksList(),
                      getString(context).tasks,
                      actions: (context) {
                        return [
                          IconButton(
                              icon: Icon(Icons.archive),
                              onPressed: () {
                                pushWidget(
                                    context,
                                    MyTaskArchive(
                                      plannerDatabase: plannerDatabase,
                                    ));
                              })
                        ];
                      },
                      navigationItem: NavigationItem.tasksList,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).exams,
                      iconData: Icons.stars, onTap: () {
                    navigationBloc.openSubChild(
                      'exams',
                      MyEventsOnlyExams(),
                      getString(context).exams,
                      navigationItem: NavigationItem.eventsExamsList,
                    );
                  }),
                ],
              ),
            ),
            FormSection(
              title: getString(context).allfunctions,
              child: Column(
                children: <Widget>[
                  getFunctionTile(context,
                      name: getString(context).grades,
                      iconData: CommunityMaterialIcons.trophy_outline,
                      onTap: () {
                    navigationBloc.openSubChild(
                      'grades',
                      GradeDetailList(plannerDatabase),
                      getString(context).grades,
                      navigationItem: NavigationItem.grades,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).teachers,
                      iconData: Icons.people_outline, onTap: () {
                    navigationBloc.openSubChild(
                      'teachers',
                      TeacherList(plannerDatabase: plannerDatabase),
                      getString(context).teachers,
                      navigationItem: NavigationItem.teachers,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).places,
                      iconData: Icons.room, onTap: () {
                    navigationBloc.openSubChild(
                      'places',
                      PlaceList(plannerDatabase: plannerDatabase),
                      getString(context).places,
                      navigationItem: NavigationItem.places,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).lessoninfos,
                      iconData: Icons.event_busy, onTap: () {
                    navigationBloc.openSubChild(
                      'lessoninfos',
                      LessonInfosList(plannerDatabase: plannerDatabase),
                      getString(context).lessoninfos,
                      navigationItem: NavigationItem.lessonInfos,
                    );
                  }),
                  getFunctionTile(
                    context,
                    name: getString(context).timetable,
                    iconData: Icons.event,
                    onTap: () {
                      navigationBloc.openSubChild(
                        'timetable',
                        TimetableView(),
                        getString(context).timetable,
                        navigationItem: NavigationItem.timetable,
                      );
                    },
                  ),
                  getFunctionTile(context,
                      name: getString(context).absenttimes,
                      iconData: Icons.not_interested, onTap: () {
                    navigationBloc.openSubChild(
                      'absenttimes',
                      MyAbsentList(plannerDatabase: plannerDatabase),
                      getString(context).absenttimes,
                      navigationItem: NavigationItem.absentTimes,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).courses,
                      iconData: Icons.widgets, onTap: () {
                    navigationBloc.openSubChild(
                      'courses',
                      CourseList(),
                      getString(context).courses,
                      navigationItem: NavigationItem.courseList,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).vacations,
                      iconData: Icons.wb_sunny, onTap: () {
                    navigationBloc.openSubChild(
                      'vacations',
                      HolidayList(),
                      getString(context).vacations,
                      navigationItem: NavigationItem.vacations,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).calendar,
                      iconData: Icons.event, onTap: () {
                    navigationBloc.openSubChild(
                      'calendar',
                      CalendarView(
                        plannerDatabase,
                      ),
                      getString(context).calendar,
                      navigationItem: NavigationItem.calendar,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).timeline,
                      iconData: Icons.timeline, onTap: () {
                    navigationBloc.openSubChild(
                      'timeline',
                      TimelineView(
                        plannerDatabase,
                      ),
                      getString(context).timeline,
                      navigationItem: NavigationItem.timeline,
                    );
                  }),
                ],
              ),
            ),
            FormSection(
              title: getString(context).addons,
              child: Column(
                children: <Widget>[
                  getFunctionTile(context,
                      name: getString(context).schoolreports,
                      iconData: Icons.assignment, onTap: () {
                    navigationBloc.openSubChild(
                      'schoolreports',
                      SchoolReportList(plannerDatabase: plannerDatabase),
                      getString(context).schoolreports,
                      navigationItem: NavigationItem.schoolreports,
                    );
                  }),
                  getFunctionTile(context,
                      name: getString(context).files,
                      iconData: Icons.attach_file, onTap: () {
                    navigationBloc.openSubChild(
                      'files',
                      FileHub(database: plannerDatabase),
                      getString(context).files,
                      navigationItem: NavigationItem.files,
                    );
                  }),
                  getFunctionTile(context,
                      name: bothlang(context, en: 'Print', de: 'Drucken'),
                      iconData: Icons.print, onTap: () {
                    navigationBloc.openSubChild(
                      'print',
                      PrintPage(),
                      bothlang(context, en: 'Print', de: 'Drucken'),
                      navigationItem: NavigationItem.files,
                    );
                  }),
                ],
              ),
            ),
            FormSpace(64.0),
          ],
        ),
      ),
    );
  }
}

class LibraryTabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _SchoolClassSection(),
          FormDivider(),
          Column(
            children: <Widget>[
              getDrawerFunctionTile(
                context,
                name: getString(context).allevents,
                iconData: Icons.event_note,
                onTap: () {
                  navigationBloc.openSubChild(
                    'allevents',
                    MyEventsList(),
                    getString(context).allevents,
                    actions: (context) {
                      return [
                        IconButton(
                            icon: Icon(Icons.archive),
                            onPressed: () {
                              pushWidget(context, MyEventsArchive());
                            })
                      ];
                    },
                    navigationItem: NavigationItem.allEvents,
                  );
                },
                navigationItem: NavigationItem.allEvents,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).tasks,
                iconData: Icons.book,
                onTap: () {
                  navigationBloc.openSubChild(
                    'tasks',
                    MyTasksList(),
                    getString(context).tasks,
                    actions: (context) {
                      return [
                        IconButton(
                            icon: Icon(Icons.archive),
                            onPressed: () {
                              pushWidget(
                                  context,
                                  MyTaskArchive(
                                    plannerDatabase: plannerDatabase,
                                  ));
                            })
                      ];
                    },
                    navigationItem: NavigationItem.tasksList,
                  );
                },
                navigationItem: NavigationItem.tasksList,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).exams,
                iconData: Icons.stars,
                onTap: () {
                  navigationBloc.openSubChild(
                    'exams',
                    MyEventsOnlyExams(),
                    getString(context).exams,
                    navigationItem: NavigationItem.eventsExamsList,
                  );
                },
                navigationItem: NavigationItem.eventsExamsList,
              ),
            ],
          ),
          FormDivider(),
          Column(
            children: <Widget>[
              getDrawerFunctionTile(
                context,
                name: getString(context).grades,
                iconData: CommunityMaterialIcons.trophy_outline,
                onTap: () {
                  navigationBloc.openSubChild(
                    'grades',
                    GradeDetailList(plannerDatabase),
                    getString(context).grades,
                    navigationItem: NavigationItem.grades,
                  );
                },
                navigationItem: NavigationItem.grades,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).teachers,
                iconData: Icons.people_outline,
                onTap: () {
                  navigationBloc.openSubChild(
                    'teachers',
                    TeacherList(plannerDatabase: plannerDatabase),
                    getString(context).teachers,
                    navigationItem: NavigationItem.teachers,
                  );
                },
                navigationItem: NavigationItem.teachers,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).places,
                iconData: Icons.room,
                onTap: () {
                  navigationBloc.openSubChild(
                    'places',
                    PlaceList(plannerDatabase: plannerDatabase),
                    getString(context).places,
                    navigationItem: NavigationItem.places,
                  );
                },
                navigationItem: NavigationItem.places,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).lessoninfos,
                iconData: Icons.event_busy,
                onTap: () {
                  navigationBloc.openSubChild(
                    'lessoninfos',
                    LessonInfosList(plannerDatabase: plannerDatabase),
                    getString(context).lessoninfos,
                    navigationItem: NavigationItem.lessonInfos,
                  );
                },
                navigationItem: NavigationItem.lessonInfos,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).timetable,
                iconData: Icons.event,
                onTap: () {
                  navigationBloc.openSubChild(
                    'timetable',
                    TimetableView(),
                    getString(context).timetable,
                    navigationItem: NavigationItem.timetable,
                  );
                },
                navigationItem: NavigationItem.timetable,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).absenttimes,
                iconData: Icons.not_interested,
                onTap: () {
                  navigationBloc.openSubChild(
                    'absenttimes',
                    MyAbsentList(plannerDatabase: plannerDatabase),
                    getString(context).absenttimes,
                    navigationItem: NavigationItem.absentTimes,
                  );
                },
                navigationItem: NavigationItem.absentTimes,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).courses,
                iconData: Icons.widgets,
                onTap: () {
                  navigationBloc.openSubChild(
                    'courses',
                    CourseList(),
                    getString(context).courses,
                    navigationItem: NavigationItem.courseList,
                  );
                },
                navigationItem: NavigationItem.courseList,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).vacations,
                iconData: Icons.wb_sunny,
                onTap: () {
                  navigationBloc.openSubChild(
                    'vacations',
                    HolidayList(),
                    getString(context).vacations,
                    navigationItem: NavigationItem.vacations,
                  );
                },
                navigationItem: NavigationItem.vacations,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).calendar,
                iconData: Icons.event,
                onTap: () {
                  navigationBloc.openSubChild(
                    'calendar',
                    CalendarView(
                      plannerDatabase,
                    ),
                    getString(context).calendar,
                    navigationItem: NavigationItem.calendar,
                  );
                },
                navigationItem: NavigationItem.calendar,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).timeline,
                iconData: Icons.timeline,
                onTap: () {
                  navigationBloc.openSubChild(
                    'timeline',
                    TimelineView(
                      plannerDatabase,
                    ),
                    getString(context).timeline,
                    navigationItem: NavigationItem.timeline,
                  );
                },
                navigationItem: NavigationItem.timeline,
              ),
            ],
          ),
          FormDivider(),
          Column(
            children: <Widget>[
              getDrawerFunctionTile(
                context,
                name: getString(context).schoolreports,
                iconData: Icons.assignment,
                onTap: () {
                  navigationBloc.openSubChild(
                    'schoolreports',
                    SchoolReportList(plannerDatabase: plannerDatabase),
                    getString(context).schoolreports,
                    navigationItem: NavigationItem.schoolreports,
                  );
                },
                navigationItem: NavigationItem.schoolreports,
              ),
              getDrawerFunctionTile(
                context,
                name: getString(context).files,
                iconData: Icons.attach_file,
                onTap: () {
                  navigationBloc.openSubChild(
                    'files',
                    FileHub(database: plannerDatabase),
                    getString(context).files,
                    navigationItem: NavigationItem.files,
                  );
                },
                navigationItem: NavigationItem.files,
              ),
              getDrawerFunctionTile(
                context,
                name: bothlang(context, en: 'Print', de: 'Drucken'),
                iconData: Icons.print,
                onTap: () {
                  navigationBloc.openSubChild(
                    'print',
                    PrintPage(),
                    getString(context).files,
                    navigationItem: NavigationItem.print,
                  );
                },
                navigationItem: NavigationItem.print,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getFunctionTile(
  BuildContext context, {
  required String name,
  IconData? iconData,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: ColoredCircleIcon(
      color: getAccentColor(context),
      icon: Icon(
        iconData ?? Icons.error_outline,
        color: getTextColor(getAccentColor(context)),
      ),
      radius: 18.0,
    ),
    title: Text(name),
    onTap: onTap,
    enabled: onTap != null,
  );
}

Widget getDrawerFunctionTile(
  BuildContext context, {
  required String name,
  required IconData iconData,
  required VoidCallback onTap,
  required NavigationItem navigationItem,
}) {
  return DrawerTile(
    icon: iconData,
    name: name,
    onTap: onTap,
    navigationItem: navigationItem,
  );
}

Widget getFunctionScaffhold(BuildContext context,
    {required String name, required Widget child}) {
  return Scaffold(
    appBar: MyAppHeader(title: name),
    body: child,
  );
}

class _SchoolClassSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return StreamBuilder<bool>(
      stream: drawerBloc.isCollapsed,
      initialData: drawerBloc.isCollapsedValue,
      builder: (context, snapshot) {
        final isCollapsed = snapshot.data!;
        if (isCollapsed) {
          return IconButton(
            icon: Icon(
              Icons.location_city,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              drawerBloc.setCollapsed(false);
            },
          );
        }
        return FormSection(
          title: getString(context).schoolclass,
          child: StreamBuilder<Map<String, SchoolClass>>(
            builder: (context, snapshot) {
              Map<String, SchoolClass> data = snapshot.data ?? {};
              return Column(
                children: [
                  for (final classinfo in data.values)
                    ListTile(
                      leading: Hero(
                          tag: 'classtag:' + classinfo.id,
                          child: ColoredCircleText(
                              text: toShortNameLength(
                                  context, classinfo.getShortname_full()),
                              color: classinfo.getDesign().primary,
                              radius: 22.0)),
                      title: Text(classinfo.name ?? '-'),
                      trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {
                            showSchoolClassMoreSheet(context,
                                classid: classinfo.id,
                                plannerdatabase: plannerDatabase);
                          }),
                      onTap: () {
                        pushWidget(
                            context,
                            SchoolClassView(
                              classid: classinfo.id,
                            ),
                            routname: 'schoolclass');
                      },
                    ),
                  if (data.isEmpty)
                    ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: getString(context).create,
                            onTap: () {
                              pushWidget(
                                  context,
                                  NewSchoolClassView(
                                    database: plannerDatabase,
                                  ));
                            },
                            iconData: Icons.add_circle_outline),
                        RButton(
                            text: getString(context).join,
                            onTap: () {
                              openGroupJoinPage(context: context);
                            },
                            iconData: Icons.link),
                      ],
                    ),
                ],
              );
            },
            stream: plannerDatabase.schoolClassInfos.stream,
            initialData: plannerDatabase.schoolClassInfos.data,
          ),
        );
      },
    );
  }
}
