//
import 'dart:async';

import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/SchoolEvent.dart';

import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/events/edit_event_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class MyEventsList extends StatelessWidget {
  MyEventsList();
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 0.0),
              child: Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      text: getString(context).all,
                      icon: Icon(Icons.hourglass_empty),
                    ),
                  ],
                  indicatorWeight: 0.1,
                  labelColor: getPrimaryColor(context),
                  indicatorColor: getPrimaryColor(context),
                  unselectedLabelColor: getClearTextColor(context),
                ),
              )),
          body: TabBarView(children: [
            MyEventsListInner(),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              pushWidget(
                  context,
                  NewSchoolEventView.Create(
                    database: plannerDatabase,
                  ));
            },
            icon: Icon(Icons.add),
            label: Text(getString(context).newevent),
          ),
        ));
  }
}

class MyEventsListInner extends StatefulWidget {
  MyEventsListInner();
  @override
  State<StatefulWidget> createState() => MyEventsListInnerState();
}

class MyEventsListInnerState extends State<MyEventsListInner>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return StreamBuilder<Map<String, SchoolEvent>>(
      stream: plannerDatabase.events.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<SchoolEvent> list = (snapshot.data ?? {})
            .values
            .where((event) => event.archived == false)
            .toList()
          ..sort((item1, item2) => item1.date!.compareTo(item2.date!));
        return UpListView<SchoolEvent>(
          items: list,
          emptyViewBuilder: (context) => EmptyListState(),
          builder: (context, item) {
            final courseInfo = item.courseid != null
                ? plannerDatabase.getCourseInfo(item.courseid!)
                : null;
            final listTile = ListTile(
              leading: courseInfo != null
                  ? ColoredCircleText(
                      text: toShortNameLength(
                          context, courseInfo.getShortname_full()),
                      color: courseInfo.getDesign()?.primary,
                      radius: 22.0)
                  : ColoredCircleIcon(
                      icon: Icon(Icons.person_outline),
                      color: getAccentColor(context),
                    ),
              title: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  item.courseid != null
                      ? Text(
                          getString(context).course +
                              ': ' +
                              (courseInfo != null
                                  ? courseInfo.getName()
                                  : item.courseid!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : nowidget(),
                  Text(
                    getString(context).date + ': ' + getDateText(item.date!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              isThreeLine: courseInfo != null,
              onTap: () {
                showEventDetailSheet(
                  context,
                  eventdata: item,
                  plannerdatabase: plannerDatabase,
                );
              },
            );
            return listTile;
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class MyEventsArchive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).archive),
      body: StreamBuilder<Map<String, SchoolEvent>?>(
        builder: (context, snapshot) {
          Map<String, SchoolEvent>? datamap = snapshot.data;
          if (datamap == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<SchoolEvent> list = datamap.values.toList()
            ..sort((t1, t2) {
              int compare = t1.date!.compareTo(t2.date!);
              if (compare != null) {
                return compare;
              } else {
                return t1.courseid?.compareTo(t2.courseid!) ?? 0;
              }
            });
          return UpListView<SchoolEvent>(
            items: list,
            emptyViewBuilder: (context) => EmptyListState(),
            builder: (context, item) {
              Course? courseInfo = item.courseid != null
                  ? plannerDatabase.getCourseInfo(item.courseid!)
                  : null;
              ListTile listTile = ListTile(
                leading: courseInfo != null
                    ? ColoredCircleText(
                        text: toShortNameLength(
                            context, courseInfo.getShortname_full()),
                        color: courseInfo.getDesign()?.primary,
                        radius: 22.0)
                    : ColoredCircleIcon(
                        icon: Icon(Icons.person_outline),
                        color: getAccentColor(context),
                      ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    item.courseid != null
                        ? Text(
                            getString(context).course +
                                ': ' +
                                (courseInfo != null
                                    ? courseInfo.getName()
                                    : item.courseid!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : nowidget(),
                    Text(
                      getString(context).date + ': ' + getDateText(item.date!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                isThreeLine: courseInfo != null,
                onTap: () {
                  showEventDetailSheet(context,
                      eventdata: item, plannerdatabase: plannerDatabase);
                },
              );
              return listTile;
            },
          );
        },
        stream: getArchiveStreamEvents(plannerDatabase),
      ),
    );
  }
}

class MyEventsOnlyExams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return Scaffold(
      body: StreamBuilder<Map<String, SchoolEvent>?>(
        stream: plannerDatabase.events.stream,
        builder: (context, snapshot) {
          Map<String, SchoolEvent>? datamap = snapshot.data;
          if (datamap == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<SchoolEvent> list = datamap.values
              .where((event) => event.type == 1 && event.archived == false)
              .toList()
            ..sort((t1, t2) {
              int compare = t1.date!.compareTo(t2.date!);
              if (compare != null) {
                return compare;
              } else {
                return t1.courseid?.compareTo(t2.courseid!) ?? 0;
              }
            });
          return UpListView<SchoolEvent>(
            items: list,
            emptyViewBuilder: (context) => EmptyListState(),
            builder: (context, item) {
              Course? courseInfo = item.courseid != null
                  ? plannerDatabase.getCourseInfo(item.courseid!)
                  : null;
              ListTile listTile = ListTile(
                leading: courseInfo != null
                    ? ColoredCircleText(
                        text: toShortNameLength(
                            context, courseInfo.getShortname_full()),
                        color: courseInfo.getDesign()?.primary,
                        radius: 22.0)
                    : ColoredCircleIcon(
                        icon: Icon(Icons.person_outline),
                        color: getAccentColor(context),
                      ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    item.courseid != null
                        ? Text(
                            getString(context).course +
                                ': ' +
                                (courseInfo != null
                                    ? courseInfo.getName()
                                    : item.courseid!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : nowidget(),
                    Text(
                      getString(context).date + ': ' + getDateText(item.date!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                isThreeLine: courseInfo != null,
                onTap: () {
                  showEventDetailSheet(context,
                      eventdata: item, plannerdatabase: plannerDatabase);
                },
              );
              return listTile;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(
              context,
              NewSchoolEventView.Create(
                database: plannerDatabase,
                type: 1,
              ));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newexam),
      ),
    );
  }
}

Stream<Map<String, SchoolEvent>> getArchiveStreamEvents(
    PlannerDatabase database) {
  StreamController<Map<String, SchoolEvent>> newcontroller = StreamController();
  Map<String, List<SchoolEvent>> unmergeddata_tooold = {};
  Map<String, List<SchoolEvent>> unmergeddata_archived = {};
  List<StreamSubscription> subscriptions = [];

  void update() {
    Map<String, SchoolEvent> compounddata = {};
    unmergeddata_archived.values.forEach((it) => compounddata
        .addAll(it.asMap().map((_, value) => MapEntry(value.eventid!, value))));
    unmergeddata_tooold.values.forEach((it) => compounddata
        .addAll(it.asMap().map((_, value) => MapEntry(value.eventid!, value))));
    newcontroller.add(compounddata);
  }

  database.courseinfo.data.keys.forEach((courseid) {
    subscriptions.add(database.dataManager
        .getEventRefCourse(courseid)
        .where('archived', isEqualTo: true)
        .snapshots()
        .listen((data) {
      unmergeddata_archived[courseid] = data.docs
          .map((snapshot) => SchoolEvent.fromData(snapshot.data()))
          .toList();
      update();
    }));
    subscriptions.add(database.dataManager
        .getEventRefCourse(courseid)
        .where('archived', isEqualTo: false)
        .where('date', isLessThan: getDateTwoWeeksAgo())
        .snapshots()
        .listen((data) {
      unmergeddata_tooold[courseid] = data.docs
          .map((snapshot) => SchoolEvent.fromData(snapshot.data()))
          .toList();
      update();
    }));
  });
  subscriptions.add(database.dataManager
      .getEventRefPrivate()
      .where('archived', isEqualTo: true)
      .snapshots()
      .listen((data) {
    unmergeddata_archived['private'] = data.docs
        .map((snapshot) => SchoolEvent.fromData(snapshot.data()))
        .toList();
    update();
  }));
  subscriptions.add(database.dataManager
      .getEventRefPrivate()
      .where('archived', isEqualTo: false)
      .where('date', isLessThan: getDateTwoWeeksAgo())
      .snapshots()
      .listen((data) {
    unmergeddata_tooold['private'] = data.docs
        .map((snapshot) => SchoolEvent.fromData(snapshot.data()))
        .toList();
    update();
  }));

  newcontroller.onCancel = () {
    subscriptions.forEach((it) => it.cancel());
  };
  return newcontroller.stream;
}

void showEventDetailSheet(
  BuildContext context, {
  required SchoolEvent eventdata,
  required PlannerDatabase plannerdatabase,
}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolEvent?>(
            stream: identifyEventRef(plannerdatabase, eventdata)!
                .snapshots()
                .map((snap) => snap.data() != null
                    ? SchoolEvent.fromData(snap.data()!)
                    : null),
            builder: (context, snapshot) {
              SchoolEvent? schoolEvent = snapshot.data;
              if (schoolEvent == null) return loadedView();
              return Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getSheetText(context, schoolEvent.title),
                  getExpandList([
                    schoolEvent.private == true
                        ? ListTile(
                            leading: Icon(Icons.person_outline),
                            title: Text(getString(context).private),
                          )
                        : nowidget(),
                    schoolEvent.courseid == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.widgets),
                            title: Text(plannerdatabase
                                .getCourseInfo(schoolEvent.courseid!)!
                                .getName()),
                          ),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text(getString(context).date +
                          ': ' +
                          getDateText(schoolEvent.date!) +
                          (schoolEvent.enddate != null
                              ? (' - ' + getDateTextShort(schoolEvent.enddate!))
                              : '')),
                    ),
                    ListTile(
                      leading: Icon(
                          eventtype_data(context)[schoolEvent.type]!.iconData),
                      title:
                          Text(eventtype_data(context)[schoolEvent.type]!.name),
                    ),
                    (schoolEvent.starttime != null ||
                            schoolEvent.endtime != null)
                        ? ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text(getString(context).timeofday +
                                ': ' +
                                (schoolEvent.starttime ?? '?') +
                                ' - ' +
                                (schoolEvent.endtime ?? '-')),
                          )
                        : nowidget(),
                    schoolEvent.detail == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.note),
                            title: Text(schoolEvent.detail),
                          ),
                    schoolEvent.files == null
                        ? nowidget()
                        : Column(
                            children: schoolEvent.files.values
                                .map((cloudfile) => ListTile(
                                      title: Text(cloudfile!.name!),
                                      leading: Icon(Icons.attach_file),
                                      subtitle: cloudfile.url == null
                                          ? null
                                          : Text(
                                              cloudfile.url!,
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                      onTap: () {
                                        OpenCloudFile(context, cloudfile);
                                      },
                                    ))
                                .toList(),
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
                                              NewSchoolEventView.Edit(
                                                database: plannerdatabase,
                                                eventData: schoolEvent,
                                              ));
                                        },
                                      ),
                                      eventdata.archived == true
                                          ? ListTile(
                                              leading: Icon(Icons.unarchive),
                                              title: Text(
                                                  getString(context).unarchive),
                                              onTap: () {
                                                if (eventdata.private) {
                                                  plannerdatabase.dataManager
                                                      .SetArchivedSchoolEvent(
                                                          eventdata, false);
                                                  popNavigatorBy(context,
                                                      text: 'schooleventid');
                                                } else {
                                                  requestSimplePermission(
                                                          context: context,
                                                          database:
                                                              plannerdatabase,
                                                          category:
                                                              PermissionAccessType
                                                                  .creator,
                                                          id: eventdata
                                                              .courseid!,
                                                          routname:
                                                              'schooleventid')
                                                      .then((result) {
                                                    if (result == true) {
                                                      plannerdatabase
                                                          .dataManager
                                                          .SetArchivedSchoolEvent(
                                                              eventdata, false);
                                                    }
                                                  });
                                                }
                                              },
                                            )
                                          : ListTile(
                                              leading: Icon(Icons.archive),
                                              title: Text(
                                                  getString(context).archive),
                                              onTap: () {
                                                if (eventdata.private) {
                                                  plannerdatabase.dataManager
                                                      .SetArchivedSchoolEvent(
                                                          eventdata, true);
                                                  popNavigatorBy(context,
                                                      text: 'schooleventid');
                                                } else {
                                                  requestSimplePermission(
                                                          context: context,
                                                          database:
                                                              plannerdatabase,
                                                          category:
                                                              PermissionAccessType
                                                                  .creator,
                                                          id: eventdata
                                                              .courseid!,
                                                          routname:
                                                              'schooleventid')
                                                      .then((result) {
                                                    if (result == true) {
                                                      plannerdatabase
                                                          .dataManager
                                                          .SetArchivedSchoolEvent(
                                                              eventdata, true);
                                                    }
                                                  });
                                                }
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
                                            if (delete == true) {
                                              if (schoolEvent.private) {
                                                plannerdatabase.dataManager
                                                    .DeleteSchoolEvent(
                                                        schoolEvent);
                                                popNavigatorBy(context,
                                                    text: 'schooleventid');
                                              } else {
                                                requestSimplePermission(
                                                        context: context,
                                                        database:
                                                            plannerdatabase,
                                                        category:
                                                            PermissionAccessType
                                                                .creator,
                                                        id: schoolEvent
                                                            .courseid!,
                                                        routname:
                                                            'schooleventid')
                                                    .then((result) {
                                                  if (result == true) {
                                                    plannerdatabase.dataManager
                                                        .DeleteSchoolEvent(
                                                            schoolEvent);
                                                  }
                                                });
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ]);
                                  },
                                  title: getString(context).more,
                                  routname: 'schooleventidmore');
                            },
                            iconData: Icons.more_horiz),
                      ],
                    ),
                  ),
                  FormSpace(16.0),
                ],
              ));
            });
      },
      routname: 'schooleventid');
}

DocumentReference<Map<String, dynamic>>? identifyEventRef(
    PlannerDatabase plannerdatabase, SchoolEvent schoolEvent) {
  if (schoolEvent.private) {
    return plannerdatabase.dataManager
        .getEventRefPrivate()
        .doc(schoolEvent.eventid);
  } else {
    if (schoolEvent.courseid != null) {
      return plannerdatabase.dataManager
          .getEventRefCourse(schoolEvent.courseid!)
          .doc(schoolEvent.eventid);
    } else {
      return null;
    }
  }
}
