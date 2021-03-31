//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/CourseTemplates.dart';
import 'package:schulplaner8/Data/planner_database/planner_connections.dart';
import 'package:schulplaner8/Data/planner_database/planner_connections_state.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner8/groups/src/bloc/edit_course_bloc.dart';
import 'package:schulplaner8/groups/src/gateway/course_gateway.dart';
import 'package:schulplaner8/groups/src/pages/edit_course_page.dart';
import 'package:schulplaner8/groups/src/pages/join_group_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/MyCloudFunctions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/GradeDetail.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_public_code.dart';
import 'package:schulplaner8/Views/SchoolPlanner/events/edit_event_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessoninfo/edit_lesson_info_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/tasks/edit_task_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'course/leave_course.dart';
import 'overview/quick_action_view.dart';

void showNewCourseSheet(BuildContext context, PlannerDatabase database) {
  showSheetBuilder(
      context: context,
      child: (context) => Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text(getString(context).createcourse),
                onTap: () {
                  Navigator.pop(context);
                  openEditCoursePage(
                    context: context,
                    editCourseBloc: EditCourseBloc.withCreateState(
                      database: database,
                      courseGateway: database.courseGateway,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.folder_open),
                title: Text(getString(context).usetemplate),
                onTap: () {
                  Navigator.pop(context);
                  pushWidget(
                      context,
                      CourseTemplatesView(
                        database: database,
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.public),
                title: Text(getString(context).joincourse),
                onTap: () {
                  Navigator.pop(context);
                  openGroupJoinPage(context: context);
                },
              ),
            ],
          ),
      title: getString(context).newcourse);
}

void showCourseMoreSheet(BuildContext context,
    {required String courseid, required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<Course?>(
            initialData: plannerdatabase.getCourseInfo(courseid),
            stream: plannerdatabase.courseinfo.getItemStream(courseid),
            builder: (context, snapshot) {
              Course? courseInfo = snapshot.data;
              if (courseInfo == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, courseInfo.getName()),
                  SingleChildScrollView(
                    child: Column(children: [
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text(getString(context).share),
                        onTap: () {
                          pushWidget(
                              context,
                              Scaffold(
                                appBar: AppBar(),
                                body: CoursePublicCodeView(
                                    courseid: courseInfo.id,
                                    database: plannerdatabase),
                              ));
                        },
                      ),
                      plannerdatabase.connectionsState.directconnections
                              .containsKey(courseInfo.id)
                          ? ListTile(
                              leading: Icon(Icons.delete_outline),
                              title: Text(getString(context).leavecourse),
                              onTap: () {
                                tryToLeaveCourse(context, courseInfo);
                              },
                            )
                          : nowidget(),
                      FormSpace(16.0),
                      StreamBuilder<PlannerConnections?>(
                        builder: (context, snapshot) {
                          PlannerConnections? connectionsdata = snapshot.data;
                          if (connectionsdata == null) {
                            return CircularProgressIndicator();
                          }
                          PlannerConnectionsState connectionsstate =
                              plannerdatabase.connectionsState;
                          return Column(
                            children: connectionsstate
                                .getConnectedSchoolClassesFor(courseid)
                                .map((classid) {
                              bool isActivated = connectionsdata
                                  .isCourseActivated(courseid, classid);
                              return getTitleCard(
                                  iconData: Icons.school,
                                  title: plannerdatabase
                                          .getClassInfo(classid)
                                          ?.getName() ??
                                      '-',
                                  content: [
                                    isActivated
                                        ? ListTile(
                                            leading: Icon(
                                                Icons.check_box_outline_blank),
                                            title: Text(getString(context)
                                                .deactivate_forme),
                                            onTap: () {
                                              Navigator.pop(context);
                                              plannerdatabase.dataManager
                                                  .ActivateCourseFromClassForUser(
                                                      classid, courseid, false);
                                            },
                                          )
                                        : ListTile(
                                            leading: Icon(Icons.check_box),
                                            title: Text(getString(context)
                                                .activate_forme),
                                            onTap: () {
                                              Navigator.pop(context);
                                              plannerdatabase.dataManager
                                                  .ActivateCourseFromClassForUser(
                                                      classid, courseid, true);
                                            },
                                          ),
                                  ]);
                            }).toList(),
                          );
                        },
                        stream: plannerdatabase.connections.stream,
                        initialData: plannerdatabase.connections.data,
                      ),
                    ]),
                  ),
                ],
              );
            });
      });
}

class QuickCreateCourseView extends StatelessWidget {
  final PlannerDatabase database;
  final String courseid;
  QuickCreateCourseView({required this.database, required this.courseid});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormSpace(8.0),
        FormSection(
          title: getString(context).create_quickly,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  QuickActionView(
                      iconData: Icons.book,
                      text: getString(context).task,
                      color: Colors.greenAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewSchoolTaskView.CreateWithData(
                              database: database,
                              courseid: courseid,
                            ));
                      }),
                  QuickActionView(
                      iconData: Icons.event_note,
                      text: getString(context).event,
                      color: Colors.blueGrey,
                      onTap: () {
                        pushWidget(
                            context,
                            NewSchoolEventView.Create(
                              database: database,
                              courseid: courseid,
                            ));
                      }),
                  QuickActionView(
                      iconData: CommunityMaterialIcons.trophy_outline,
                      text: getString(context).grade,
                      color: Colors.indigoAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewGradeView(
                              database,
                              courseid: courseid,
                            ));
                      }),
                  QuickActionView(
                      iconData: Icons.info_outline,
                      text: getString(context).info,
                      color: Colors.purpleAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewLessonInfoView(
                              database,
                              courseid: courseid,
                            ));
                      }),
                ],
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        )
      ],
    );
  }
}

class CourseSecurityView extends StatelessWidget {
  final String courseid;
  final PlannerDatabase database;
  CourseSecurityView({required this.courseid, required this.database});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course?>(
      builder: (context, snapshot) {
        Course? courseInfo = snapshot.data;
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design? courseDesign = courseInfo.getDesign();
        return Theme(
          data: newAppThemeDesign(context, courseDesign),
          child: Scaffold(
            appBar: MyAppHeader(
                title: getString(context).security +
                    ' ' +
                    getString(context).in_ +
                    ' ' +
                    courseInfo.getName()),
            body: getDefaultList([
              SwitchListTile(
                value: courseInfo.settings.isPublic,
                title: Text(bothlang(context,
                    de: 'Öffentliches Fach', en: 'Public course')),
                onChanged: (newvalue) {
                  ValueNotifier<bool?> notifier =
                      showPermissionStateSheet(context: context);
                  requestPermissionCourse(
                          database: database,
                          category: PermissionAccessType.settings,
                          courseid: courseid)
                      .then((result) {
                    notifier.value = result;
                    if (result == true) {
                      database.dataManager.getCourseInfo(courseid).set(
                        {
                          'settings': {
                            'isPublic': newvalue,
                          }
                        },
                        SetOptions(
                          merge: true,
                        ),
                      );
                    }
                  });
                },
              ),
            ]),
          ),
        );
      },
      stream: database.courseinfo.getItemStream(courseid),
    );
  }
}

class CourseTemplatesView extends StatelessWidget {
  final List<dynamic> templates = getTemplateList_DE();
  final PlannerDatabase database;

  CourseTemplatesView({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).templates),
      body: StreamBuilder<Map<String, Course>>(
          stream: database.courseinfo.stream,
          builder: (context, snapshot) {
            List<Course> allmycourses = snapshot.data?.values.toList() ?? [];
            return ListView.separated(
              itemBuilder: (context, index) {
                dynamic item = templates[index];
                if (item is CourseTemplate) {
                  bool enabledtemplate = !item.isAlreadyaCourse(allmycourses);
                  return ListTile(
                    leading: ColoredCircleText(
                        text: item.shortname,
                        color: item.design.primary,
                        radius: 22.0),
                    title: Text(item.name),
                    trailing: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: enabledtemplate
                              ? () {
                                  final courseGateway = CourseGateway(
                                    database.root,
                                    database.getMemberIdObject(),
                                  );
                                  courseGateway.CreateCourseAsCreator(
                                    Course.fromTemplate(
                                      courseid: database.dataManager
                                          .generateCourseId(),
                                      template: item,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(bothlang(context,
                                              de: '${item.name} erstellt',
                                              en: '${item.name} created.'))));
                                }
                              : null,
                          tooltip: getString(context).add,
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: enabledtemplate
                              ? () {
                                  openEditCoursePage(
                                    context: context,
                                    editCourseBloc:
                                        EditCourseBloc.withCreateState(
                                      template: item,
                                      database: database,
                                      courseGateway: database.courseGateway,
                                    ),
                                  );
                                }
                              : null,
                          tooltip: getString(context).edit,
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    enabled: enabledtemplate,
                  );
                } else if (item is TemplateCategory) {
                  return FormHeader(item.name);
                } else {
                  return loadedView();
                }
              },
              itemCount: templates.length,
              separatorBuilder: (BuildContext context, index) {
                return (templates[index] is CourseTemplate)
                    ? Divider()
                    : nowidget();
              },
            );
          }),
    );
  }
}

class CourseConnectedClassesView extends StatelessWidget {
  final String courseid;
  final PlannerDatabase database;
  CourseConnectedClassesView({required this.courseid, required this.database});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course?>(
      builder: (context, snapshot) {
        Course? courseInfo = snapshot.data;
        Design? courseDesign = courseInfo?.getDesign();
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Theme(
            data: newAppThemeDesign(context, courseDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title:
                      '${getString(context).connectedclasses} ${getString(context).in_} ' +
                          courseInfo.getName()),
              body: ListView(
                children: courseInfo.connectedclasses.keys.map((item) {
                  SchoolClass? mClassinfo =
                      database.schoolClassInfos.data[item];
                  if (mClassinfo != null) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          FormSpace(8.0),
                          ListTile(
                            leading: ColoredCircleText(
                                text: mClassinfo.getShortname(length: 3),
                                color: mClassinfo.getDesign().primary,
                                radius: 22.0),
                            title: Text(mClassinfo.name),
                            trailing: Builder(
                              builder: (context) {
                                return RButton(
                                    text: getString(context).connected,
                                    onTap: null,
                                    iconData: Icons.done,
                                    enabled: false,
                                    disabledColor: Colors.green);
                              },
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.people),
                            title: Text(
                                (mClassinfo.membersData.length.toString() ) +
                                    bothlang(context,
                                        de: 'Mitglieder', en: 'Members')),
                          ),
                          ListTile(
                            leading: Icon(Icons.widgets),
                            title: Text((mClassinfo.courses.length
                                        .toString()) +
                                bothlang(context, de: 'Fächer', en: 'Courses')),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              RButton(
                                  text: getString(context).remove,
                                  iconData: Icons.remove_circle_outline,
                                  onTap: () {
                                    showConfirmDialog(
                                            context: context,
                                            title: bothlang(context,
                                                de: 'Aus Klasse entfernen',
                                                en: 'Remove from class'),
                                            action: getString(context).remove,
                                            richtext: null)
                                        .then((result) {
                                      if (result == true) {
                                        Navigator.pop(context);
                                        ValueNotifier<bool?> sheet_notifier =
                                            ValueNotifier(null);
                                        showLoadingStateSheet(
                                            context: context,
                                            sheetUpdate: sheet_notifier);
                                        requestPermissionCourse(
                                                database: database,
                                                category:
                                                    PermissionAccessType.edit,
                                                courseid: courseid)
                                            .then((result) {
                                          if (result == true) {
                                            removeCourseToClass(
                                                    classid: mClassinfo.id,
                                                    courseid: courseInfo.id)
                                                .then((result) {
                                              sheet_notifier.value = result;
                                            });
                                          } else {
                                            sheet_notifier.value = false;
                                          }
                                        });
                                      }
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return FutureBuilder<SchoolClass>(
                      builder: (context, snapshot) {
                        SchoolClass? info = snapshot.data;
                        if (info == null) return CircularProgressIndicator();
                        return Card(
                          child: Column(
                            children: <Widget>[
                              FormSpace(8.0),
                              ListTile(
                                leading: ColoredCircleText(
                                    text: info.getShortname(length: 3),
                                    color: info.getDesign().primary,
                                    radius: 22.0),
                                title: Text(info.name),
                                trailing: Builder(
                                  builder: (context) {
                                    return RButton(
                                        text: getString(context).connected,
                                        onTap: null,
                                        iconData: Icons.done,
                                        enabled: false,
                                        disabledColor: Colors.green);
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.people),
                                title: Text(
                                    (info.membersData.length.toString() ) +
                                        getString(context).members),
                              ),
                              ListTile(
                                leading: Icon(Icons.widgets),
                                title: Text(
                                    (info.courses.length.toString() ) +
                                        getString(context).courses),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  RButton(
                                      text: getString(context).remove,
                                      iconData: Icons.remove_circle_outline,
                                      onTap: () {
                                        showConfirmDialog(
                                                context: context,
                                                title: bothlang(context,
                                                    de: 'Aus Klasse entfernen',
                                                    en: 'Remove from class'),
                                                action:
                                                    getString(context).remove,
                                                richtext: null)
                                            .then((result) {
                                          if (result == true) {
                                            Navigator.pop(context);
                                            ValueNotifier<bool?>
                                                sheet_notifier =
                                                ValueNotifier(null);
                                            showLoadingStateSheet(
                                                context: context,
                                                sheetUpdate: sheet_notifier);
                                            requestPermissionCourse(
                                                    database: database,
                                                    category:
                                                        PermissionAccessType
                                                            .edit,
                                                    courseid: courseid)
                                                .then((result) {
                                              if (result == true) {
                                                removeCourseToClass(
                                                        classid: info.id,
                                                        courseid: courseInfo.id)
                                                    .then((result) {
                                                  sheet_notifier.value = result;
                                                });
                                              } else {
                                                sheet_notifier.value = false;
                                              }
                                            });
                                          }
                                        });
                                      })
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      future: getSchoolClassInformation(item),
                    );
                  }
                }).toList(),
              ),
            ));
      },
      stream: database.courseinfo.getItemStream(courseid),
    );
  }
}
