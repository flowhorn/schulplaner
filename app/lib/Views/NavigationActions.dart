import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/OldRest/CalendarView.dart';
import 'package:schulplaner8/OldRest/Timeline.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyEvents.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Upcoming.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/grades/grade_details_list.dart';
import 'package:schulplaner8/groups/src/pages/course_list.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

final Map<int, NavigationActionItem> allNavigationActions = {
  1: NavigationActionItem(
    id: 1,
    iconData: Icons.event,
    name: TranslationString((context) => getString(context).timetable),
    builder: (context) => TimetableView(),
    navigationItem: NavigationItem.timetable,
  ),
  2: NavigationActionItem(
    id: 2,
    iconData: Icons.list,
    name: TranslationString((context) => getString(context).upcoming),
    builder: (context) => UpcomingView(),
    navigationItem: NavigationItem.upcoming,
  ),
  3: NavigationActionItem(
    id: 3,
    iconData: Icons.widgets,
    name: TranslationString((context) => getString(context).courses),
    builder: (context) => CourseList(),
    navigationItem: NavigationItem.courseList,
  ),
  4: NavigationActionItem(
    id: 4,
    iconData: Icons.timeline,
    name: TranslationString((context) => getString(context).timeline),
    builder: (context) => TimelineView(
      BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!,
    ),
    navigationItem: NavigationItem.timeline,
  ),
  5: NavigationActionItem(
    id: 5,
    iconData: Icons.event,
    name: TranslationString((context) => getString(context).calendar),
    builder: (context) => CalendarView(
      BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!,
    ),
    navigationItem: NavigationItem.calendar,
  ),
  6: NavigationActionItem(
    id: 6,
    iconData: Icons.book,
    name: TranslationString((context) => getString(context).tasks),
    builder: (context) => MyTasksList(),
    navigationItem: NavigationItem.tasksList,
  ),
  7: NavigationActionItem(
    id: 7,
    iconData: Icons.event_note,
    name: TranslationString((context) => getString(context).allevents),
    builder: (context) => MyEventsList(),
    navigationItem: NavigationItem.allEvents,
  ),
  8: NavigationActionItem(
    id: 8,
    iconData: Icons.stars,
    name: TranslationString((context) => getString(context).exams),
    builder: (context) => MyEventsOnlyExams(),
    navigationItem: NavigationItem.eventsExamsList,
  ),
  9: NavigationActionItem(
    id: 9,
    iconData: CommunityMaterialIcons.trophy_outline,
    name: TranslationString((context) => getString(context).grades),
    builder: (context) => GradeDetailList(
      BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!,
    ),
    navigationItem: NavigationItem.grades,
  ),
  10: NavigationActionItem(
    id: 10,
    iconData: Icons.event_busy,
    name: TranslationString((context) => getString(context).lessoninfos),
    builder: (context) => LessonInfosList(
      plannerDatabase:
          BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!,
    ),
    navigationItem: NavigationItem.lessonInfos,
  ),
};
