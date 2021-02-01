import 'dart:async';

import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Views/widgets/quick_create_view.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyEvents.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/holidays/holiday_details_page.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

class UpcomingView extends StatelessWidget {
  UpcomingView();
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    List<Holiday> nextvacations = getNextVacations(context, plannerDatabase);
    return ListView(
      children: <Widget>[
        QuickCreateView(),
        FormHeader2(getString(context).vacations),
        nextvacations.isNotEmpty
            ? Column(
                children: nextvacations.map((item) {
                  return ListTile(
                    leading: ColoredCircleIcon(
                      icon: Icon(Icons.wb_sunny),
                    ),
                    title: Text(item.name.text),
                    subtitle: item.start == item.end
                        ? Text(item.start.parser.toMMMEd)
                        : Text(
                            item.start.parser.toMMMEd +
                                ' - ' +
                                item.end.parser.toMMMEd,
                          ),
                    onTap: () {
                      showVacationDetail(
                          context: context,
                          plannerdatabase: plannerDatabase,
                          holidayID: item.id);
                    },
                    trailing: Card(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          getVacationText(item, context),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                  );
                }).toList(),
              )
            : ListTile(
                title: Text(getString(context).noupcomingvacations + ' :/'),
              ),
        FormDivider(),
        FormHeader2(getString(context).briefly),
        UpcomingTasksEventsView(plannerDatabase),
        FormSpace(16.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ButtonBar(
            children: <Widget>[
              RButton(
                  text: getString(context).allevents,
                  onTap: () {
                    NavigationBloc.of(context).openSubChild(
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
                  iconData: Icons.event),
              RButton(
                  text: getString(context).tasks,
                  onTap: () {
                    NavigationBloc.of(context).openSubChild(
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
                  iconData: Icons.book),
              RButton(
                  text: getString(context).exams,
                  onTap: () {
                    NavigationBloc.of(context).openSubChild(
                      'exams',
                      MyEventsOnlyExams(),
                      getString(context).exams,
                      navigationItem: NavigationItem.eventsExamsList,
                    );
                  },
                  iconData: Icons.stars),
            ],
          ),
        ),
        FormSpace(16.0),
      ],
    );
  }
}

class UpcomingTasksEventsView extends StatelessWidget {
  final PlannerDatabase database;
  UpcomingTasksEventsView(
    this.database,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: getTaskEventUpcomingStream(database),
      initialData: getTaskEventUpcomingStream_initialdata(database),
      builder: (context, snapshot) {
        List<dynamic> list = snapshot.data;
        if (list == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: list.map((item) {
            if (item is SchoolTask) {
              bool isFinished = item.isFinished(database.getMemberId());
              Course courseInfo = item.courseid != null
                  ? database.getCourseInfo(item.courseid)
                  : null;
              ListTile listTile = ListTile(
                leading: courseInfo != null
                    ? ColoredCircleText(
                        text: toShortNameLength(
                            context, courseInfo.getShortname_full()),
                        color: courseInfo.getDesign().primary,
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
                subtitle:
                    Text(getString(context).due + ': ' + getDateText(item.due)),
                trailing: isFinished
                    ? IconButton(
                        icon: Icon(
                          Icons.done_outline,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          database.dataManager
                              .SetFinishedSchoolTask(item, false);
                        })
                    : IconButton(
                        icon: Icon(
                          Icons.hourglass_empty,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          database.dataManager
                              .SetFinishedSchoolTask(item, true);
                        }),
                onTap: () {
                  showTaskDetailSheet(
                    context,
                    taskid: item.taskid,
                    plannerdatabase: database,
                  );
                },
              );
              return (isFinished == false)
                  ? Dismissible(
                      key: Key(item.taskid + isFinished.toString()),
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
            }
            if (item is SchoolEvent) {
              Course courseInfo = item.courseid != null
                  ? database.getCourseInfo(item.courseid)
                  : null;
              ListTile listTile = ListTile(
                leading: courseInfo != null
                    ? ColoredCircleText(
                        text: toShortNameLength(
                            context, courseInfo.getShortname_full()),
                        color: courseInfo.getDesign().primary,
                        radius: 18.0)
                    : ColoredCircleIcon(
                        icon: Icon(Icons.person_outline),
                        color: getAccentColor(context),
                        radius: 18.0,
                      ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('' + getDateText(item.date)),
                onTap: () {
                  showEventDetailSheet(
                    context,
                    eventdata: item,
                    plannerdatabase: database,
                  );
                },
              );
              return listTile;
            }
            return Text('null');
          }).toList(),
        );
      },
    );
  }
}

Stream<List<dynamic>> getTaskEventUpcomingStream(PlannerDatabase database) {
  final controller = StreamController<List<dynamic>>();
  final subs = <StreamSubscription>[];

  Iterable<SchoolTask> tasks;
  Iterable<SchoolEvent> events;

  void update() {
    final newlist = <dynamic>[];
    if (tasks != null) newlist.addAll(tasks);
    if (events != null) newlist.addAll(events);
    newlist.sort((e1, e2) {
      String getdate(dynamic e) {
        if (e is SchoolTask) return e.due;
        if (e is SchoolEvent) return e.date;
        return '-';
      }

      String getTitle(dynamic e) {
        if (e is SchoolTask) return e.title;
        if (e is SchoolEvent) return e.title;
        return '-';
      }

      bool getFinished(dynamic e) {
        if (e is SchoolTask) return e.isFinished(database.getMemberId());
        if (e is SchoolEvent) return false;
        return false;
      }

      final compareDue = getdate(e1).compareTo(getdate(e2));
      if (compareDue != 0) return compareDue;
      final compareFinished =
          getFinished(e1).toString().compareTo(getFinished(e2).toString());
      if (compareFinished != 0) return compareFinished;
      return getTitle(e1).compareTo(getTitle(e2));
    });
    controller.add(newlist);
  }

  subs.add(database.tasks.stream.listen((data) {
    tasks = data.values.where((taskitem) {
      if (taskitem.archived == true) return false;
      return isInNextXDays(taskitem.due, 5);
    });
    update();
  }));
  subs.add(database.events.stream.listen((data) {
    events = data.values.where((evenitem) {
      if (evenitem.archived == true) return false;
      return isInNextXDays(evenitem.date, 5);
    });
    update();
  }));
  controller.onCancel = () {
    subs.forEach((it) => it.cancel());
  };
  return controller.stream;
}

List<dynamic> getTaskEventUpcomingStream_initialdata(PlannerDatabase database) {
  final tasks = database.tasks.data.values.where((taskitem) {
    if (taskitem.archived == true) return false;
    return isInNextXDays(taskitem.due, 5);
  });
  final events = database.events.data.values.where((evenitem) {
    if (evenitem.archived == true) return false;
    return isInNextXDays(evenitem.date, 5);
  });

  final newlist = <dynamic>[];
  if (tasks != null) newlist.addAll(tasks);
  if (events != null) newlist.addAll(events);
  newlist.sort((e1, e2) {
    String getdate(dynamic e) {
      if (e is SchoolTask) return e.due;
      if (e is SchoolEvent) return e.date;
      return '-';
    }

    String getTitle(dynamic e) {
      if (e is SchoolTask) return e.title;
      if (e is SchoolEvent) return e.title;
      return '-';
    }

    bool getFinished(dynamic e) {
      if (e is SchoolTask) return e.isFinished(database.getMemberId());
      if (e is SchoolEvent) return false;
      return false;
    }

    int compareDue = getdate(e1).compareTo(getdate(e2));
    if (compareDue != 0) return compareDue;
    int compareFinished =
        getFinished(e1).toString().compareTo(getFinished(e2).toString());
    if (compareFinished != 0) return compareFinished;
    return getTitle(e1).compareTo(getTitle(e2));
  });
  return newlist;
}

List<Holiday> getNextVacations(BuildContext context, PlannerDatabase database,
    {int length = 2}) {
  Iterable<Holiday> vacations = database.vacations.data.values.where((item) {
    DateTime datetime = DateTime.now();
    DateTime vacationstart = item.start.toDateTime;
    DateTime vacationend = item.end.toDateTime;
    if (vacationstart.isAfter(datetime)) {
      if (getDiffToVacation(item, context) > 50) return false;
      return true;
    }
    if ((vacationstart.isBefore(datetime) ||
                isSameDay(item.start.toDateString,
                    parseDateString(datetime))) //CONDITION 1
            &&
            (vacationend.isAfter(datetime) ||
                isSameDay(item.end.toDateString,
                    parseDateString(datetime))) //CONDITION 2
        ) {
      return true;
    } else {
      return false;
    }
  });
  List<Holiday> list = vacations.toList();
  list.sort((v1, v2) {
    return v1.start.toDateString.compareTo(v2.start.toDateString);
  });
  return list.getRange(0, list.length > length ? length : list.length).toList();
}

String getVacationText(Holiday item, BuildContext context) {
  DateTime datetime = parseDate(getDateToday());
  DateTime vacationstart = item.start.toDateTime;
  DateTime vacationend = item.end.toDateTime;
  if (vacationstart.isAfter(datetime)) {
    Duration duration = vacationstart.difference(datetime);
    return getString(context).in_ +
        ' ' +
        duration.inDays.toString() +
        ' ' +
        getString(context).indays;
  } else {
    if ((vacationstart.isBefore(datetime) ||
                isSameDay(item.start.toDateString,
                    parseDateString(datetime))) //CONDITION 1
            &&
            (vacationend.isAfter(datetime) ||
                isSameDay(item.end.toDateString,
                    parseDateString(datetime))) //CONDITION 2
        ) {
      return getString(context).current;
    } else {
      return '???';
    }
  }
}

int getDiffToVacation(Holiday item, BuildContext context) {
  DateTime datetime = parseDate(getDateToday());
  DateTime vacationstart = item.start.toDateTime;
  Duration duration = vacationstart.difference(datetime);
  return duration.inDays;
}
