//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/SmartCalAPI.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/OldRest/Calendar.dart';
import 'package:schulplaner8/OldRest/flutter_calendar/flutter_calendar.dart';
import 'package:schulplaner8/Views/SchoolPlanner/timeline/timeline_tile.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';

class CalendarView extends StatefulWidget {
  final PlannerDatabase database;
  const CalendarView(this.database);
  @override
  State<StatefulWidget> createState() => CalendarViewState(database);
}

class CalendarViewState extends State<CalendarView> {
  final PlannerDatabase database;

  late Map<String, Lesson> lessons;
  late Map<String, LessonInfo> lessoninfos;
  late List<Holiday> vacations;
  late Map<String, SchoolEvent> schoolevents;
  late Map<String, SchoolTask> schooltasks;

  late List<StreamSubscription> subs;

  CalendarViewState(this.database) {
    subs = [];
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
    CalendarSettings calsettings =
        getAppSettings(context).configurationData.calendarSettings;
    return Calendar(
      database,
      onDateSelected: (DateTime newtime) {
        showCalendarItemSheet(context, parseDateString(newtime), database);
      },
      dayBuilder: (BuildContext context, day) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !calsettings.getVacation().enabled
                ? nowidget()
                : !isVacation(day, database.vacations.data.values.toList())
                    ? nowidget()
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: calsettings.getVacation().color,
                        ),
                        height: 6.0,
                        width: 6.0),
            !calsettings.getEvent().enabled
                ? nowidget()
                : !isEvent(parseDateString(day),
                        database.events.data.values.toList())
                    ? nowidget()
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: calsettings.getEvent().color,
                        ),
                        height: 6.0,
                        width: 6.0),
            !calsettings.getTask().enabled
                ? nowidget()
                : !isTask(parseDateString(day),
                        database.tasks.data.values.toList())
                    ? nowidget()
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: calsettings.getTask().color,
                        ),
                        height: 6.0,
                        width: 6.0),
            !calsettings.getTestAndExam().enabled
                ? nowidget()
                : !isTestExam(parseDateString(day),
                        database.events.data.values.toList())
                    ? nowidget()
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: calsettings.getTestAndExam().color,
                        ),
                        height: 6.0,
                        width: 6.0),
            !calsettings.getWeekend().enabled
                ? nowidget()
                : !isWeekend(day, database)
                    ? nowidget()
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: calsettings.getWeekend().color,
                        ),
                        height: 6.0,
                        width: 6.0),
          ],
        );
      },
    );
  }
}

void showCalendarItemSheet(
    BuildContext context, String datestring, PlannerDatabase database) {
  showSheetBuilder(
      context: context,
      child: (context) {
        int weekday = parseDate(datestring).weekday;
        int weektype = getWeektypeofDate(datestring, database);
        return StreamBuilder<Map<String, dynamic>>(
          builder: (context, data) {
            if (data.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, Lesson> lessons = data.data!['lessons']!;
            Map<String, LessonInfo> lessoninfos = data.data!['lessoninfos']!;
            ;
            Map<String, SchoolEvent> schoolevents = data.data!['schoolevents']!;
            Map<String, SchoolTask> schooltasks = data.data!['schooltasks']!;

            return Flexible(
                child: SingleChildScrollView(
              child: TimelineTile(database,
                  weektype: weektype,
                  date: datestring,
                  tasks: (schooltasks).values.where((item) {
                    return item.due == datestring;
                  }).toList(),
                  events: (schoolevents).values.where((item) {
                    return item.date == datestring;
                  }).toList(),
                  lessonInfos: (lessoninfos).values.where((item) {
                    return item.date == datestring;
                  }).toList(),
                  lessons: (lessons).values.where((lesson) {
                    if (lesson.day != weekday) return false;
                    if (lesson.correctWeektype(weektype)) {
                      return true;
                    } else {
                      return false;
                    }
                  }).toList()),
            ));
          },
          stream: getAdvancedCalendarStream(database, datestring),
        );
      },
      title: getDateText(datestring));
}

bool isEvent(String date, List<SchoolEvent> list) {
  List<SchoolEvent> eventlist = list.where((SchoolEvent v) {
    if (v.getDateKeys().contains(date)) {
      return true;
    } else {
      return false;
    }
  }).toList();
  if (eventlist.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

bool isTask(String datestring, List<SchoolTask> list) {
  List<SchoolTask> filteredlist = list.where((SchoolTask t) {
    if (t.due == datestring) {
      return true;
    } else {
      return false;
    }
  }).toList();

  if (filteredlist.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

bool isTestExam(String datestring, List<SchoolEvent> list) {
  List<SchoolEvent> filteredlist = list.where((SchoolEvent t) {
    if (t.date == datestring) {
      EventTypes eventType = EventTypes.values[t.type];
      if (eventType == EventTypes.TEST || eventType == EventTypes.EXAM) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }).toList();

  if (filteredlist.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Stream<Map<String, dynamic>> getAdvancedCalendarStream(
    PlannerDatabase database, String date) {
  StreamController<Map<String, dynamic>> controller = StreamController();
  List<StreamSubscription> subs = [];
  late Map<String, Lesson>? lessons;
  late Map<String, LessonInfo>? lessoninfos;
  late Map<String, SchoolEvent>? schoolevents;
  late Map<String, SchoolTask>? schooltasks;

  void update() {
    controller.add({
      'lessons': lessons ?? {},
      'lessoninfos': lessoninfos ?? {},
      'schoolevents': schoolevents ?? {},
      'schooltasks': schooltasks ?? {},
    });
  }

  subs.add(database.getLessonsStream().listen((newdata) {
    lessons = newdata;
    update();
  }));
  subs.add(database.tasks.stream.listen((newdata) {
    schooltasks = newdata;
    update();
  }));
  subs.add(database.events.stream.listen((newdata) {
    schoolevents = newdata;
    update();
  }));
  subs.add(database.lessoninfos.stream.listen((newdata) {
    lessoninfos = newdata;
    update();
  }));

  controller.onCancel = () {
    subs.forEach((it) => it.cancel());
  };

  return controller.stream;
}
