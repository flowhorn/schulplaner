import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/SmartCalAPI.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/OldRest/Timeline.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyEvents.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/tasks/edit_task_page.dart';
import 'package:schulplaner8/Views/widgets/lesson_item.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

class TimelineTile extends StatelessWidget {
  final PlannerDatabase database;
  final String date;
  final List<SchoolTask> tasks;
  final List<SchoolEvent> events;
  final List<Lesson> lessons;
  final List<LessonInfo> lessonInfos;
  final int weektype;

  TimelineTile(
    this.database, {
    required this.weektype,
    required this.date,
    required this.tasks,
    required this.events,
    required this.lessons,
    required this.lessonInfos,
  });

  @override
  Widget build(BuildContext context) {
    DayType dayType = getDayType(date, database);

    bool showEvents, showTasks, showLessons;
    if (tasks.isNotEmpty) {
      showTasks = true;
    } else {
      showTasks = false;
    }
    if (events.isNotEmpty) {
      showEvents = true;
    } else {
      showEvents = false;
    }
    showLessons =
        getAppSettings(context).configurationData.timelineSettings.showLessons;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: getDividerColor(context),
        ),
      ),
      child: Column(
        children: <Widget>[
          _TimelineTileSectionTitle(
            database: database,
            date: date,
            weektype: weektype,
          ),
          dayType.isSchoolDay()
              ? nowidget()
              : Builder(builder: (context) {
                  if (dayType.type == DayTypes.WEEKEND) {
                    return Container(
                      child: ListTile(
                          leading: Icon(Icons.weekend),
                          title: Text(getString(context).weekend)),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: getDividerColor(context),
                          ),
                        ),
                      ),
                    );
                  }
                  if (dayType.type == DayTypes.VACATION) {
                    return HolidayTile_Timeline(
                      holiday: dayType.vacationItem!,
                    );
                  }
                  return Container();
                }),
          (dayType.isSchoolDay()) ? FormSpace(8.0) : nowidget(),
          (dayType.isSchoolDay() && showLessons)
              ? _TimelineTileSectionLessons(
                  database: database,
                  date: date,
                  lessons: lessons,
                  lessonInfos: lessonInfos,
                )
              : nowidget(),
          showEvents
              ? _TimelineTileSectionEvents(
                  database: database,
                  date: date,
                  events: events,
                )
              : nowidget(),
          showTasks
              ? _TimelineTileSectionTasks(
                  database: database,
                  date: date,
                  tasks: _getSortedTasks(),
                )
              : nowidget(),
          //FormDivider(),
        ],
      ),
    );
  }

  List<SchoolTask> _getSortedTasks() {
    return tasks
      ..sort((task1, task2) {
        int compareDue = task1.due!.compareTo(task2.due!);
        if (compareDue != 0) return compareDue;
        int compareFinished = task1
            .isFinished(database.getMemberId())
            .toString()
            .compareTo(task2.isFinished(database.getMemberId()).toString());
        if (compareFinished != 0) return compareFinished;
        return task1.title.compareTo(task2.title);
      });
  }
}

class _TimelineTileSectionTitle extends StatelessWidget {
  final PlannerDatabase database;
  final String date;
  final int weektype;

  const _TimelineTileSectionTitle({
    Key? key,
    required this.database,
    required this.date,
    required this.weektype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = parseDate(date);
    return Tile(
      leading: Hero(
          tag: 'timelineitem' + date,
          child: ColoredCircleText(
            text: getWeekDays(context)[dateTime.weekday]?.name.substring(0, 2),
            radius: 16.0,
          )),
      title: Text(getDateNoWeekDayText(date)),
      trailing: IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            showPickerCreateAtDate(context, database, date);
          }),
      subtitle: weektype == 0
          ? null
          : Text(weektypes(context)[weektype]?.name ?? '-'),
    );
  }
}

class _TimelineTileSectionLessons extends StatelessWidget {
  final PlannerDatabase database;
  final String date;
  final List<Lesson> lessons;
  final List<LessonInfo> lessonInfos;

  const _TimelineTileSectionLessons({
    Key? key,
    required this.database,
    required this.date,
    required this.lessons,
    required this.lessonInfos,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //FormHeader(getString(context).lessons),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (lessons
                  ..sort((l1, l2) {
                    return l1.start.compareTo(l2.start);
                  }))
                .map(
              (it) {
                final Course? courseInfo = database.getCourseInfo(it.courseid!);
                final LessonInfo? lessonInfo =
                    getFirst(lessonInfos.where((lit) {
                  return lit.lessonid == it.lessonid;
                }));
                return LessonItemTimeline(
                  color: courseInfo?.getDesign()?.primary,
                  courseName: courseInfo?.getShortname_full(),
                  start: it.start,
                  end: it.end,
                  lessonInfoType: lessonInfo == null ? null : lessonInfo.type,
                  onTap: () {
                    showLessonDetailSheet(context,
                        lessonid: it.lessonid!,
                        plannerdatabase: database,
                        datestring: date);
                  },
                  onLongPress: () {
                    pushWidget(
                        context,
                        NewSchoolTaskView.CreateWithData(
                          database: database,
                          courseid: it.courseid,
                        ));
                  },
                );
              },
            ).toList(),
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        FormSpace(3.0),
      ],
    );
  }
}

class _TimelineTileSectionTasks extends StatelessWidget {
  final PlannerDatabase database;
  final String date;
  final List<SchoolTask> tasks;

  const _TimelineTileSectionTasks({
    Key? key,
    required this.database,
    required this.date,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormHeader(getString(context).tasks),
        Column(
          children: tasks.map((item) {
            bool isFinished = item.isFinished(database.getMemberId());
            final Course? courseInfo = item.courseid != null
                ? database.getCourseInfo(item.courseid!)
                : null;
            final listTile = ListTile(
              leading: courseInfo != null
                  ? ColoredCircleText(
                      text: toShortNameLength(
                          context, courseInfo.getShortname_full()),
                      color: courseInfo.getDesign()?.primary,
                      radius: 18.0)
                  : ColoredCircleIcon(
                      icon: Icon(Icons.person_outline),
                      color: getAccentColor(context),
                    ),
              title: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: isFinished
                  ? IconButton(
                      icon: Icon(
                        Icons.done_outline,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        database.dataManager.SetFinishedSchoolTask(item, false);
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        database.dataManager.SetFinishedSchoolTask(item, true);
                      }),
              onTap: () {
                showTaskDetailSheet(context,
                    taskid: item.taskid!, plannerdatabase: database);
              },
            );
            return (isFinished == false)
                ? Dismissible(
                    key: Key(item.taskid! + isFinished.toString()),
                    onDismissed: (direction) {
                      database.dataManager.SetFinishedSchoolTask(item, true);
                    },
                    background: Container(
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.done),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.done),
                        ),
                      ),
                    ),
                    child: listTile,
                  )
                : listTile;
          }).toList(),
        ),
        FormSpace(3.0),
      ],
    );
  }
}

class _TimelineTileSectionEvents extends StatelessWidget {
  final PlannerDatabase database;
  final String date;
  final List<SchoolEvent> events;

  const _TimelineTileSectionEvents({
    Key? key,
    required this.database,
    required this.date,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormHeader(getString(context).events),
        Column(
          children: events.map((item) {
            final Course? courseInfo = item.courseid != null
                ? database.getCourseInfo(item.courseid!)
                : null;
            ListTile listTile = ListTile(
              leading: courseInfo != null
                  ? ColoredCircleText(
                      text: toShortNameLength(
                          context, courseInfo.getShortname_full()),
                      color: courseInfo.getDesign()?.primary,
                      radius: 18.0)
                  : ColoredCircleIcon(
                      icon: Icon(Icons.person_outline),
                      color: getAccentColor(context),
                      radius: 18.0,
                    ),
              title: Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (item.type == 1 || item.type == 2)
                      ? TextStyle(color: Colors.redAccent)
                      : null),
              onTap: () {
                showEventDetailSheet(context,
                    eventdata: item, plannerdatabase: database);
              },
            );
            return listTile;
          }).toList(),
        ),
        FormSpace(3.0),
      ],
    );
  }
}

class HolidayTile_Timeline extends StatelessWidget {
  final Holiday holiday;

  const HolidayTile_Timeline({
    Key? key,
    required this.holiday,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Tile(
        leading: Icon(Icons.wb_sunny),
        title: Text(holiday.name.text),
        subtitle: Text(holiday.start!.parser.toMMMEd +
            ' - ' +
            holiday.end!.parser.toMMMEd),
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: getDividerColor(context),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final Widget? leading, title, subtitle, trailing;

  const Tile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68.0,
      child: Row(
        children: <Widget>[
          if (leading != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: leading,
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null)
                  DefaultTextStyle(
                    child: title!,
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                if (subtitle != null)
                  DefaultTextStyle(
                    child: subtitle!,
                    style: Theme.of(context).textTheme.bodyText2!,
                  ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          if (trailing != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: trailing,
            ),
        ],
      ),
    );
  }
}
