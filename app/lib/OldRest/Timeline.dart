//@dart=2.11
import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyAbsentTime.dart';
import 'package:schulplaner8/Helper/SmartCalAPI.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/events/edit_event_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessoninfo/edit_lesson_info_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/tasks/edit_task_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/timeline/timeline_tile.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

enum EventType { SCHOOLDAY, VACATION, WEEKEND }

class Weekend {
  String startdate, enddate;
  int duration;

  Weekend(this.duration, this.startdate, this.enddate);
}

class ShortTimelineView extends StatefulWidget {
  final PlannerDatabase database;
  ShortTimelineView(this.database);
  @override
  State<StatefulWidget> createState() => ShortTimelineViewState(database);
}

class ShortTimelineViewState extends State<ShortTimelineView> {
  PlannerDatabase database;

  String getDateString(int position) {
    return parseDateString(DateTime.now().add(Duration(days: position)));
  }

  Map<String, Lesson> lessons;
  Map<String, LessonInfo> lessoninfos;
  List<Holiday> vacations;
  Map<String, SchoolEvent> schoolevents;
  Map<String, SchoolTask> schooltasks;

  List<StreamSubscription> subs;

  ShortTimelineViewState(this.database) {
    subs = [];
    lessons = database.getLessons();
    schooltasks = database.tasks.data;
    schoolevents = database.events.data;
    lessoninfos = database.lessoninfos.data;
  }

  @override
  void initState() {
    super.initState();
    subs.add(database.getLessonsStream().listen((newdata) {
      setState(() {
        lessons = newdata;
      });
    }));
    subs.add(database.tasks.stream.listen((newdata) {
      setState(() {
        schooltasks = newdata;
      });
    }));
    subs.add(database.events.stream.listen((newdata) {
      setState(() {
        schoolevents = newdata;
      });
    }));
    subs.add(database.lessoninfos.stream.listen((newdata) {
      setState(() {
        lessoninfos = newdata;
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    subs.forEach((it) => it.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormHeader2(getString(context).nextdays),
        Column(
          children:
              buildIntList(getConfigurationData(context).general_daysinhome - 1)
                  .map((index) {
            String datestring = getDateString(index);
            int weekday = parseDate(datestring).weekday;
            int weektype = getWeektypeofDate(datestring, database);
            return Padding(
              padding: EdgeInsets.all(
                4.0,
              ),
              child: TimelineTile(
                database,
                weektype: weektype,
                date: datestring,
                tasks: (schooltasks ?? {}).values.where((item) {
                  if (item.archived == true) return false;
                  return item.due == datestring;
                }).toList(),
                events: (schoolevents ?? {}).values.where((item) {
                  if (item.archived == true) return false;
                  return item.getDateKeys().contains(datestring);
                }).toList(),
                lessonInfos: (lessoninfos ?? {}).values.where((item) {
                  return item.date == datestring;
                }).toList(),
                lessons: (lessons ?? {}).values.where((lesson) {
                  if (lesson.day != weekday) return false;
                  if (lesson.correctWeektype(weektype)) {
                    return true;
                  } else {
                    return false;
                  }
                }).toList(),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class TimelineView extends StatefulWidget {
  final PlannerDatabase database;
  TimelineView(this.database);
  @override
  State<StatefulWidget> createState() => TimelineViewState(database);
}

class TimelineViewState extends State<TimelineView> {
  final PlannerDatabase database;

  String getDateString(int position) {
    return parseDateString(DateTime.now().add(Duration(days: position)));
  }

  Map<String, Lesson> lessons;
  Map<String, LessonInfo> lessoninfos;
  List<Holiday> vacations;
  Map<String, SchoolEvent> schoolevents;
  Map<String, SchoolTask> schooltasks;

  List<StreamSubscription> subs;

  TimelineViewState(
    this.database,
  ) {
    subs = [];
    lessons = database.getLessons();
    schooltasks = database.tasks.data;
    schoolevents = database.events.data;
    lessoninfos = database.lessoninfos.data;
  }

  @override
  void initState() {
    super.initState();
    subs.add(database.getLessonsStream().listen((newdata) {
      setState(() {
        lessons = newdata;
      });
    }));
    subs.add(database.tasks.stream.listen((newdata) {
      setState(() {
        schooltasks = newdata;
      });
    }));
    subs.add(database.events.stream.listen((newdata) {
      setState(() {
        schoolevents = newdata;
      });
    }));
    subs.add(database.lessoninfos.stream.listen((newdata) {
      setState(() {
        lessoninfos = newdata;
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    subs.forEach((it) => it.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        String datestring = getDateString(index);
        int weekday = parseDate(datestring).weekday;
        int weektype = getWeektypeofDate(datestring, database);
        return TimelineTile(database,
            weektype: weektype,
            date: datestring,
            tasks: (schooltasks ?? {}).values.where((item) {
              if (item.archived == true) return false;
              return item.due == datestring;
            }).toList(),
            events: (schoolevents ?? {}).values.where((item) {
              if (item.archived == true) return false;
              return item.getDateKeys().contains(datestring);
            }).toList(),
            lessonInfos: (lessoninfos ?? {}).values.where((item) {
              return item.date == datestring;
            }).toList(),
            lessons: (lessons ?? {}).values.where((lesson) {
              if (lesson.day != weekday) return false;
              if (lesson.correctWeektype(weektype)) {
                return true;
              } else {
                return false;
              }
            }).toList());
      },
      cacheExtent: 100.0,
    );
  }
}

void showPickerCreateAtDate(
    BuildContext context, PlannerDatabase database, String date) {
  showSheetBuilder(
      context: context,
      child: (context) {
        return getFlexList([
          simpleTile(
              iconData: Icons.book,
              text: getString(context).newtask,
              color: Colors.greenAccent,
              onTap: () {
                Navigator.pop(context);
                pushWidget(
                    context,
                    NewSchoolTaskView.CreateWithData(
                      database: database,
                      due: date,
                    ));
              }),
          simpleTile(
              iconData: Icons.event_note,
              text: getString(context).newevent,
              color: Colors.blueGrey,
              onTap: () {
                Navigator.pop(context);
                pushWidget(
                    context,
                    NewSchoolEventView.Create(
                      database: database,
                      date: date,
                    ));
              }),
          simpleTile(
              iconData: CommunityMaterialIcons.trophy_outline,
              text: getString(context).newgrade,
              color: Colors.indigoAccent,
              onTap: () {
                Navigator.pop(context);
                pushWidget(
                    context,
                    NewGradeView(
                      database,
                      date: date,
                    ));
              }),
          simpleTile(
              iconData: Icons.info_outline,
              text: getString(context).newlessoninfo,
              color: Colors.purpleAccent,
              onTap: () {
                Navigator.pop(context);
                pushWidget(
                    context,
                    NewLessonInfoView(
                      database,
                      datestring: date,
                    ));
              }),
          simpleTile(
              iconData: Icons.not_interested,
              text: getString(context).newabsenttime,
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                pushWidget(
                    context,
                    NewAbsentTimeView.Create(
                      database: database,
                      date: date,
                    ));
              }),
        ]);
      },
      title: getDateText(date));
}

Widget simpleTile({
  IconData iconData,
  String text,
  Color color,
  VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(
      iconData,
      color: color,
    ),
    title: Text(text),
    onTap: onTap,
  );
}

T getFirst<T>(Iterable<T> iterable) {
  if ((iterable?.length ?? 0) > 0) {
    return iterable.first;
  } else {
    return null;
  }
}

class TimeLineLessonItem extends StatelessWidget {
  final Lesson lesson;
  final Course course;
  final PlannerDatabase database;
  final LessonInfo lessoninfo;
  final String datestring;

  const TimeLineLessonItem(
    this.lesson,
    this.course,
    this.database,
    this.lessoninfo,
    this.datestring,
  );

  @override
  Widget build(BuildContext context) {
    if (course == null) return CircularProgressIndicator();
    return InkWell(
      child: Container(
        height: 68.0,
        width: 56.0,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text((lesson.isMultiLesson()
                  ? lesson.start.toString() +
                      '. - ' +
                      lesson.end.toString() +
                      '. '
                  : lesson.start.toString() + '. ')),
            ),
            Align(
              alignment: Alignment.center,
              child: ColoredCircleText(
                color: course.getDesign().primary,
                text: toShortNameLength(context, course.getShortname_full()),
                radius: 24.0,
                textsize: 19.0,
              ),
            ),
          ],
        ),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            color: lessoninfo != null
                ? getLessonInfoColor(lessoninfo.type)
                : null),
      ),
      onTap: () {
        showLessonDetailSheet(context,
            lessonid: lesson.lessonid,
            plannerdatabase: database,
            datestring: datestring);
      },
      onLongPress: () {
        pushWidget(
            context,
            NewSchoolTaskView.CreateWithData(
              database: database,
              courseid: lesson.courseid,
            ));
      },
    );
  }
}
