import 'dart:async';
import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Task.dart';
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
import 'package:schulplaner8/Views/SchoolPlanner/tasks/edit_task_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:share/share.dart';

class RecommendedDate {
  String text, date;
  RecommendedDate({required this.date, required this.text});
}

Stream<Map<String, SchoolTask>> streamFinished(
    PlannerDatabase database, bool finished) {
  return database.tasks.stream.map(
    (data) {
      return {
        for (final it in data.values.where((it) {
          if (it.archived) {
            return false;
          }
          return (it.isFinished(database.getMemberId()) == finished);
        }))
          it.taskid!: it,
      };
    },
  );
}

class MyTasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plannerDatabase =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase!;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 100.0),
              child: Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      text: getString(context).open,
                      icon: Icon(Icons.hourglass_empty),
                    ),
                    Tab(
                      text: getString(context).done,
                      icon: Icon(Icons.done_outline),
                    ),
                  ],
                  indicatorWeight: 3.0,
                  labelColor: getAccentColor(context),
                  indicatorColor: getAccentColor(context),
                  unselectedLabelColor: getClearTextColor(context),
                ),
              )),
          body: TabBarView(children: [
            MyTaskListInner(plannerDatabase, false),
            MyTaskListInner(plannerDatabase, true),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              pushWidget(context, NewSchoolTaskView(database: plannerDatabase));
            },
            icon: Icon(Icons.add),
            label: Text(getString(context).newtask),
          ),
        ));
  }
}

class MyTaskListInner extends StatefulWidget {
  final PlannerDatabase plannerDatabase;
  final bool finished;
  MyTaskListInner(this.plannerDatabase, this.finished);
  @override
  State<StatefulWidget> createState() => MyTaskListInnerState();
}

class MyTaskListInnerState extends State<MyTaskListInner>
    with AutomaticKeepAliveClientMixin {
  PlannerDatabase get plannerDatabase => widget.plannerDatabase;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<Map<String, SchoolTask>>(
      stream: streamFinished(widget.plannerDatabase, widget.finished),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SchoolTask> tasklist = (snapshot.data ?? {}).values.toList()
            ..sort((item1, item2) => item1.due!.compareTo(item2.due!));
          return UpListView<SchoolTask>(
            items: tasklist,
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
                      getString(context).due + ': ' + getDateText(item.due!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                isThreeLine: courseInfo != null,
                trailing: item.isFinished(plannerDatabase.getMemberId())
                    ? IconButton(
                        icon: Icon(
                          Icons.done_outline,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          plannerDatabase.dataManager
                              .SetFinishedSchoolTask(item, false);
                        })
                    : IconButton(
                        icon: Icon(
                          Icons.hourglass_empty,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          plannerDatabase.dataManager
                              .SetFinishedSchoolTask(item, true);
                        }),
                onTap: () {
                  showTaskDetailSheet(context,
                      taskid: item.taskid!, plannerdatabase: plannerDatabase);
                },
              );
              return (widget.finished == false)
                  ? Dismissible(
                      key: Key(item.taskid! +
                          item
                              .isFinished(plannerDatabase.getMemberId())
                              .toString()),
                      onDismissed: (direction) {
                        plannerDatabase.dataManager
                            .SetFinishedSchoolTask(item, true);
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
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class MyTaskArchive extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  MyTaskArchive({required this.plannerDatabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).archive),
      body: StreamBuilder<Map<String, SchoolTask>?>(
        builder: (context, snapshot) {
          Map<String, SchoolTask>? datamap = snapshot.data;
          if (datamap == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<SchoolTask> list = datamap.values.toList()
            ..sort((t1, t2) {
              if (t1.isFinished(plannerDatabase.getMemberId())) return -1;
              if (t2.isFinished(plannerDatabase.getMemberId())) return 1;
              int compare = t1.due!.compareTo(t2.due!);
              if (compare != 0) {
                return compare;
              } else {
                return t1.courseid!.compareTo(t2.courseid!);
              }
            });
          return UpListView<SchoolTask>(
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
                      getString(context).due + ': ' + getDateText(item.due!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                isThreeLine: courseInfo != null,
                onTap: () {
                  showTaskDetailSheetCritical(
                    context,
                    task: item,
                    plannerdatabase: plannerDatabase,
                  );
                },
                trailing: item.isFinished(plannerDatabase.getMemberId())
                    ? IconButton(
                        icon: Icon(
                          Icons.done_outline,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          plannerDatabase.dataManager
                              .SetFinishedSchoolTask(item, false);
                        })
                    : IconButton(
                        icon: Icon(
                          Icons.hourglass_empty,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          plannerDatabase.dataManager
                              .SetFinishedSchoolTask(item, true);
                        }),
              );
              return listTile;
            },
          );
        },
        stream: getArchiveStream(plannerDatabase),
      ),
    );
  }
}

Stream<Map<String, SchoolTask>> getArchiveStream(PlannerDatabase database) {
  StreamController<Map<String, SchoolTask>> newcontroller = StreamController();
  Map<String, List<SchoolTask>> unmergeddata_tooold = {};
  Map<String, List<SchoolTask>> unmergeddata_archived = {};
  List<StreamSubscription> subscriptions = [];

  void update() {
    Map<String, SchoolTask> compounddata = {};
    unmergeddata_archived.values.forEach((it) => compounddata
        .addAll(it.asMap().map((_, value) => MapEntry(value.taskid!, value))));
    unmergeddata_tooold.values.forEach((it) => compounddata
        .addAll(it.asMap().map((_, value) => MapEntry(value.taskid!, value))));
    newcontroller.add(compounddata);
  }

  database.courseinfo.data.keys.forEach((courseid) {
    subscriptions.add(database.dataManager
        .getTaskRefCourse(courseid)
        .where('archived', isEqualTo: true)
        .snapshots()
        .listen((data) {
      unmergeddata_archived[courseid] = data.docs
          .map((snapshot) => SchoolTask.fromData(snapshot.data()))
          .toList();
      update();
    }));
    subscriptions.add(database.dataManager
        .getTaskRefCourse(courseid)
        .where('archived', isEqualTo: false)
        .where('due', isLessThan: getDateTwoWeeksAgo())
        .snapshots()
        .listen((data) {
      unmergeddata_tooold[courseid] = data.docs
          .map((snapshot) => SchoolTask.fromData(snapshot.data()))
          .toList();
      update();
    }));
  });
  subscriptions.add(database.dataManager
      .getTaskRefPrivate()
      .where('archived', isEqualTo: true)
      .snapshots()
      .listen((data) {
    unmergeddata_archived['private'] = data.docs
        .map((snapshot) => SchoolTask.fromData(snapshot.data()))
        .toList();
    update();
  }));
  subscriptions.add(database.dataManager
      .getTaskRefPrivate()
      .where('archived', isEqualTo: false)
      .where('due', isLessThan: getDateTwoWeeksAgo())
      .snapshots()
      .listen((data) {
    unmergeddata_tooold['private'] = data.docs
        .map((snapshot) => SchoolTask.fromData(snapshot.data()))
        .toList();
    update();
  }));

  newcontroller.onCancel = () {
    subscriptions.forEach((it) => it.cancel());
  };
  return newcontroller.stream;
}

void showTaskDetailSheet(BuildContext context,
    {required String taskid, required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolTask?>(
          stream: plannerdatabase.tasks.getItemStream(taskid),
          builder: (context, snapshot) {
            SchoolTask? schoolTask = snapshot.data;
            if (schoolTask == null) return loadedView();
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getSheetText(context, schoolTask.title),
                  getExpandList([
                    schoolTask.private == true
                        ? ListTile(
                            leading: Icon(Icons.person_outline),
                            title: Text(getString(context).private),
                          )
                        : nowidget(),
                    schoolTask.courseid == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.widgets),
                            title: Text(
                              plannerdatabase
                                  .getCourseInfo(schoolTask.courseid!)!
                                  .getName(),
                            ),
                          ),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text(getString(context).due +
                          ': ' +
                          getDateText(schoolTask.due!)),
                    ),
                    schoolTask.detail == null
                        ? nowidget()
                        : ListTile(
                            leading: Icon(Icons.note),
                            title: Text(schoolTask.detail),
                          ),
                    schoolTask.files == null
                        ? nowidget()
                        : Column(
                            children: schoolTask.files.values
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
                          text: getString(context).finished,
                          onTap: () {
                            plannerdatabase.dataManager
                                .SetFinishedSchoolTask(schoolTask, true);
                            Navigator.pop(context);
                          },
                          iconData: Icons.done_outline,
                          enabled: !schoolTask
                              .isFinished(plannerdatabase.getMemberId()),
                          disabledColor: Colors.green,
                        ),
                        RButton(
                            text: getString(context).more,
                            onTap: () {
                              showSheetBuilder(
                                  context: context,
                                  child: (context) {
                                    return getFlexList([
                                      schoolTask.isFinished(plannerdatabase
                                                  .getMemberId()) ==
                                              true
                                          ? ListTile(
                                              leading: Icon(Icons.done),
                                              title: Text(getString(context)
                                                  .notyetfinished),
                                              onTap: () {
                                                Navigator.pop(context);
                                                plannerdatabase.dataManager
                                                    .SetFinishedSchoolTask(
                                                        schoolTask, false);
                                              },
                                            )
                                          : nowidget(),
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text(getString(context).edit),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pushWidget(
                                              context,
                                              NewSchoolTaskView(
                                                database: plannerdatabase,
                                                editmode: true,
                                                editmode_taskid:
                                                    schoolTask.taskid,
                                              ));
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.share),
                                        title: Text(getString(context).share),
                                        onTap: () {
                                          Navigator.pop(context);
                                          String coursename =
                                              schoolTask.courseid != null
                                                  ? plannerdatabase
                                                      .getCourseInfo(
                                                          schoolTask.courseid!)!
                                                      .getName()
                                                  : '/';
                                          String msg = schoolTask.title +
                                              (schoolTask.detail != null
                                                  ? ('\n' + schoolTask.detail)
                                                  : '') +
                                              '\n' +
                                              getString(context).course +
                                              ': ' +
                                              coursename +
                                              '\n' +
                                              getString(context).due +
                                              ': ' +
                                              getDateText(schoolTask.due!);

                                          Share.share(msg);
                                        },
                                      ),
                                      schoolTask.archived == true
                                          ? ListTile(
                                              leading: Icon(Icons.unarchive),
                                              title: Text(
                                                  getString(context).unarchive),
                                              onTap: () {
                                                if (schoolTask.private) {
                                                  popNavigatorBy(context,
                                                      text: 'schooltaskid');
                                                  plannerdatabase.dataManager
                                                      .SetArchivedSchoolTask(
                                                          schoolTask, false);
                                                } else {
                                                  requestSimplePermission(
                                                          context: context,
                                                          database:
                                                              plannerdatabase,
                                                          category:
                                                              PermissionAccessType
                                                                  .creator,
                                                          id: schoolTask
                                                              .courseid!,
                                                          routname:
                                                              'schooltaskid')
                                                      .then((result) {
                                                    if (result == true) {
                                                      plannerdatabase
                                                          .dataManager
                                                          .SetArchivedSchoolTask(
                                                              schoolTask,
                                                              false);
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
                                                if (schoolTask.private) {
                                                  popNavigatorBy(context,
                                                      text: 'schooltaskid');
                                                  plannerdatabase.dataManager
                                                      .SetArchivedSchoolTask(
                                                          schoolTask, true);
                                                } else {
                                                  requestSimplePermission(
                                                          context: context,
                                                          database:
                                                              plannerdatabase,
                                                          category:
                                                              PermissionAccessType
                                                                  .creator,
                                                          id: schoolTask
                                                              .courseid!,
                                                          routname:
                                                              'schooltaskid')
                                                      .then((result) {
                                                    if (result == true) {
                                                      plannerdatabase
                                                          .dataManager
                                                          .SetArchivedSchoolTask(
                                                              schoolTask, true);
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
                                              if (schoolTask.private) {
                                                plannerdatabase.dataManager
                                                    .DeleteSchoolTask(
                                                        schoolTask);
                                                popNavigatorBy(context,
                                                    text: 'schooltaskid');
                                              } else {
                                                requestSimplePermission(
                                                        context: context,
                                                        database:
                                                            plannerdatabase,
                                                        category:
                                                            PermissionAccessType
                                                                .creator,
                                                        id: schoolTask
                                                            .courseid!,
                                                        routname:
                                                            'schooltaskid')
                                                    .then((result) {
                                                  if (result == true) {
                                                    plannerdatabase.dataManager
                                                        .DeleteSchoolTask(
                                                            schoolTask);
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
                                  routname: 'schooltaskidmore');
                            },
                            iconData: Icons.more_horiz),
                      ],
                    ),
                  ),
                  FormSpace(16.0),
                ],
              ),
            );
          },
        );
      },
      routname: 'schooltaskid');
}

void showTaskDetailSheetCritical(BuildContext context,
    {required SchoolTask task, required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolTask?>(
            stream: identifyTaskRef(plannerdatabase, task)!.snapshots().map(
                (snap) => snap.data() != null
                    ? SchoolTask.fromData(snap.data()!)
                    : null),
            builder: (context, snapshot) {
              SchoolTask? schoolTask = snapshot.data;
              if (schoolTask == null) return loadedView();
              return Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getSheetText(context, schoolTask.title),
                  getExpandList(
                    [
                      schoolTask.private == true
                          ? ListTile(
                              leading: Icon(Icons.person_outline),
                              title: Text(getString(context).private),
                            )
                          : nowidget(),
                      schoolTask.courseid == null
                          ? nowidget()
                          : ListTile(
                              leading: Icon(Icons.widgets),
                              title: Text(plannerdatabase
                                  .getCourseInfo(schoolTask.courseid!)!
                                  .getName()),
                            ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text(getString(context).due +
                            ': ' +
                            getDateText(schoolTask.due!)),
                      ),
                      schoolTask.detail == null
                          ? nowidget()
                          : ListTile(
                              leading: Icon(Icons.note),
                              title: Text(schoolTask.detail),
                            ),
                      schoolTask.files == null
                          ? nowidget()
                          : Column(
                              children: schoolTask.files.values
                                  .map((cloudfile) => ListTile(
                                        title: Text(cloudfile!.name!),
                                        leading: Icon(Icons.attach_file),
                                        subtitle: cloudfile.url == null
                                            ? null
                                            : Text(
                                                cloudfile.url!,
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                        onTap: () {
                                          OpenCloudFile(context, cloudfile);
                                        },
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonBar(
                      children: <Widget>[
                        RButton(
                          text: getString(context).finished,
                          onTap: () {
                            plannerdatabase.dataManager
                                .SetFinishedSchoolTask(schoolTask, true);
                          },
                          iconData: Icons.done_outline,
                          enabled: !schoolTask
                              .isFinished(plannerdatabase.getMemberId()),
                          disabledColor: Colors.green,
                        ),
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
                                              NewSchoolTaskView
                                                  .fromCriticalEdit(
                                                database: plannerdatabase,
                                                task: schoolTask,
                                              ));
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.share),
                                        title: Text(getString(context).share),
                                        onTap: () {
                                          Navigator.pop(context);
                                          String coursename =
                                              schoolTask.courseid != null
                                                  ? plannerdatabase
                                                      .getCourseInfo(
                                                          schoolTask.courseid!)!
                                                      .getName()
                                                  : '/';
                                          String msg = schoolTask.title +
                                              '\n' +
                                              schoolTask.detail +
                                              '\n' +
                                              getString(context).course +
                                              ': ' +
                                              coursename +
                                              '\n' +
                                              getString(context).due +
                                              ': ' +
                                              getDateText(schoolTask.due!);

                                          Share.share(msg);
                                        },
                                      ),
                                      schoolTask.archived == true
                                          ? ListTile(
                                              leading: Icon(Icons.unarchive),
                                              title: Text(
                                                  getString(context).unarchive),
                                              onTap: () {
                                                if (schoolTask.private) {
                                                  popNavigatorBy(context,
                                                      text: 'schooltaskid');
                                                  plannerdatabase.dataManager
                                                      .SetArchivedSchoolTask(
                                                          schoolTask, false);
                                                } else {
                                                  requestSimplePermission(
                                                          context: context,
                                                          database:
                                                              plannerdatabase,
                                                          category:
                                                              PermissionAccessType
                                                                  .creator,
                                                          id: schoolTask
                                                              .courseid!,
                                                          routname:
                                                              'schooltaskid')
                                                      .then((result) {
                                                    if (result == true) {
                                                      plannerdatabase
                                                          .dataManager
                                                          .SetArchivedSchoolTask(
                                                              schoolTask,
                                                              false);
                                                    }
                                                  });
                                                }
                                              },
                                            )
                                          : nowidget(),
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
                                              if (schoolTask.private) {
                                                plannerdatabase.dataManager
                                                    .DeleteSchoolTask(
                                                        schoolTask);
                                                popNavigatorBy(context,
                                                    text: 'schooltaskid');
                                              } else {
                                                requestSimplePermission(
                                                        context: context,
                                                        database:
                                                            plannerdatabase,
                                                        category:
                                                            PermissionAccessType
                                                                .creator,
                                                        id: schoolTask
                                                            .courseid!,
                                                        routname:
                                                            'schooltaskid')
                                                    .then((result) {
                                                  if (result == true) {
                                                    plannerdatabase.dataManager
                                                        .DeleteSchoolTask(
                                                            schoolTask);
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
                                  routname: 'schooltaskidmore');
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
      routname: 'schooltaskid');
}

DocumentReference<Map<String, dynamic>>? identifyTaskRef(
    PlannerDatabase plannerdatabase, SchoolTask schoolTask) {
  if (schoolTask.private) {
    return plannerdatabase.dataManager
        .getTaskRefPrivate()
        .doc(schoolTask.taskid);
  } else {
    if (schoolTask.courseid != null) {
      return plannerdatabase.dataManager
          .getTaskRefCourse(schoolTask.courseid!)
          .doc(schoolTask.taskid);
    } else {
      return null;
    }
  }
}
