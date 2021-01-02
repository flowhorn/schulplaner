import 'dart:async';
import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Data/Planner/CourseTemplates.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/leave_schoolclass.dart';
import 'package:schulplaner8/groups/src/bloc/edit_course_bloc.dart';
import 'package:schulplaner8/groups/src/gateway/course_gateway.dart';
import 'package:schulplaner8/groups/src/pages/edit_course_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/MyCloudFunctions.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/school_class/school_class_public_code.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

void showSchoolClassMoreSheet(BuildContext context,
    {@required String classid, @required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolClass>(
            stream: plannerdatabase.schoolClassInfos.getItemStream(classid),
            builder: (context, snapshot) {
              SchoolClass info = snapshot.data;
              if (info == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, info.getName() ?? "-"),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(getString(context).edit),
                    onTap: () {
                      pushWidget(
                          context,
                          NewSchoolClassView(
                            database: plannerdatabase,
                            editmode_classid: info.id,
                            editmode: true,
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text(getString(context).share),
                    onTap: () {
                      pushWidget(
                          context,
                          Scaffold(
                            appBar: AppBar(),
                            body: SchoolClassPublicCodeView(
                                classid: info.id, database: plannerdatabase),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text(getString(context).remove),
                    onTap: () {
                      tryToLeaveSchoolClass(context, info);
                    },
                    enabled: plannerdatabase.connectionsState.classconnections
                        .containsKey(info.id),
                  ),
                  FormSpace(16.0),
                ],
              );
            });
      },
      routname: "schoolclass");
}

class NewSchoolClassView extends StatelessWidget {
  final PlannerDatabase database;
  final bool editmode;
  final String editmode_classid;
  bool changedValues = false;
  bool addToPrivateCourses = true;
  String addToClass;

  SchoolClass data;
  ValueNotifier<SchoolClass> notifier;

  ValueNotifier<bool> showSeveralForm = ValueNotifier(false);

  NewSchoolClassView(
      {@required this.database, this.editmode = false, this.editmode_classid}) {
    if (editmode) {
      data = database.schoolClassInfos.data[editmode_classid].copyWith();
    } else {
      data = SchoolClass.Create(
        database.dataManager.generateSchoolClassId(),
        database.getSettings(),
        database.getMemberId(),
      ).copyWith(design: getRandomDesign(null));
    }
    notifier = ValueNotifier(data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ValueListenableBuilder<SchoolClass>(
            valueListenable: notifier,
            builder: (context, _, _2) {
              if (data == null) return CircularProgressIndicator();
              return Theme(
                  data: newAppThemeDesign(context, data?.design),
                  child: Scaffold(
                    appBar: MyAppHeader(
                        title: editmode
                            ? getString(context).editschoolclass
                            : getString(context).newschoolclass),
                    body: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        FormHeader(getString(context).general),
                        FormTextField(
                          text: data.name,
                          valueChanged: (newtext) {
                            data = data.copyWith(name: newtext);
                            changedValues = true;
                          },
                          labeltext: getString(context).name,
                        ),
                        FormSpace(12.0),
                        FormTextField(
                          text: data.shortname,
                          valueChanged: (newtext) {
                            data = data.copyWith(shortname: newtext);
                            changedValues = true;
                          },
                          iconData: Icons.short_text,
                          labeltext: getString(context).shortname,
                          maxLengthEnforced: true,
                          maxLength: 5,
                        ),
                        FormSpace(6.0),
                        ListTile(
                          leading: Icon(
                            Icons.color_lens,
                            color: data.design?.primary ?? Colors.grey,
                          ),
                          title: Text(getString(context).design),
                          subtitle: Text(data.design?.name ?? "-"),
                          trailing: IconButton(
                              icon: Icon(Icons.autorenew),
                              onPressed: () {
                                changedValues = true;
                                SchoolClass newdata = data.copyWith(
                                    design: getRandomDesign(context));
                                data = newdata;
                                notifier.value = newdata;
                              }),
                          onTap: () {
                            selectDesign(context, data.design?.id)
                                .then((newdesign) {
                              if (newdesign != null) {
                                changedValues = true;
                                SchoolClass newdata =
                                    data.copyWith(design: newdesign);
                                data = newdata;
                                notifier.value = newdata;
                              }
                            });
                          },
                        ),
                        FormSpace(6.0),
                        FormDivider(),
                        FormHideable(
                            title: getString(context).advanced,
                            notifier: showSeveralForm,
                            builder: (context) => Column(
                                  children: <Widget>[
                                    FormSpace(8.0),
                                    FormTextField(
                                      text: data.description,
                                      valueChanged: (newtext) {
                                        data = data.copyWith(
                                          description: newtext,
                                        );
                                        changedValues = true;
                                      },
                                      labeltext: getString(context).description,
                                    ),
                                    FormSpace(8.0),
                                  ],
                                )),
                        FormDivider(),
                        FormSpace(64.0),
                      ],
                    )),
                    floatingActionButton: FloatingActionButton.extended(
                        onPressed: () {
                          if (data.validate()) {
                            if (editmode) {
                              requestSimplePermission(
                                      context: context,
                                      database: database,
                                      category: PermissionAccessType.edit,
                                      id: data.id,
                                      type: 1)
                                  .then((result) {
                                if (result == true) {
                                  database.dataManager.ModifySchoolClass(data);
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              database.schoolClassGateway
                                  .CreateSchoolClassAsCreator(data);
                              Navigator.pop(context);
                            }
                          } else {
                            final infoDialog = InfoDialog(
                              title: getString(context).failed,
                              message: getString(context).pleasecheckdata,
                            );
                            // ignore: unawaited_futures
                            infoDialog.show(context);
                          }
                        },
                        icon: Icon(Icons.done),
                        label: Text(getString(context).done)),
                  ));
            }),
        onWillPop: () async {
          if (changedValues == false) return true;
          return showConfirmDialog(
              context: context,
              title: getString(context).discardchanges,
              action: getString(context).confirm,
              richtext: RichText(
                  text: TextSpan(
                text: getString(context).currentchangesnotsaved,
              ))).then((value) {
            if (value == true) {
              return true;
            } else {
              return false;
            }
          });
        });
  }
}

class SchoolClassCoursesView extends StatelessWidget {
  final String classid;
  final PlannerDatabase database;
  SchoolClassCoursesView({@required this.classid, @required this.database});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
        ThreeObjects<SchoolClass, PlannerConnections, Map<String, Course>>>(
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        SchoolClass classInfo = snapshot.data.item;
        //PlannerConnections connections = snapshot.data.item2;
        Map<String, Course> allcourses = snapshot.data.item3;
        Future.value(null).then((_) {
          classInfo.courses.forEach((key, value) {
            if (classInfo?.id == null) return;
            Course courseinfo = database.courseinfo.data[key];
            if (courseinfo != null) {
              if (courseinfo.connectedclasses.containsKey(classInfo.id) ==
                  false) {
                database.dataManager
                    .ConnectCourseToSchoolClassSens(courseinfo, classid);
              }
            }
          });
        });
        Design classDesign = classInfo?.getDesign();
        return Theme(
            data: newAppThemeDesign(context, classDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title:
                      "${getString(context).courses} ${getString(context).in_} " +
                          classInfo.getName()),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ...(classInfo.courses.keys.map((item) {
                      String courseid = item;
                      Course courseInfo = allcourses[courseid];

                      Widget getListTileCourse(Course courseInfo) {
                        return StreamBuilder<PlannerConnections>(
                          stream: database.connections.stream,
                          initialData: database.connections.data,
                          builder: (context, snapshot) {
                            PlannerConnections connections = snapshot.data;
                            bool isActivated = connections.isCourseActivated(
                                courseid, classid);
                            return ListTile(
                              leading: SizedBox(
                                height: 44.0,
                                width: 44.0,
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: isActivated ? 1.0 : 0.5,
                                      child: Hero(
                                          tag: "courestag:" + courseInfo.id,
                                          child: ColoredCircleText(
                                              text: toShortNameLength(
                                                  context,
                                                  courseInfo
                                                      .getShortname_full()),
                                              color: courseInfo
                                                  .getDesign()
                                                  .primary,
                                              radius: 22.0)),
                                    ),
                                    isActivated
                                        ? Container()
                                        : Center(
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.red[200],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              title: Text(courseInfo.name),
                              subtitle: Column(
                                children: <Widget>[
                                  Text(
                                    getString(context).teacher +
                                        ": " +
                                        courseInfo.getTeachersListed(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(getString(context).place +
                                      ": " +
                                      courseInfo.getPlacesListed()),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: () {
                                    showSheetBuilder(
                                        context: context,
                                        child: (context) {
                                          return getFlexList([
                                            isActivated
                                                ? ListTile(
                                                    leading: Icon(Icons
                                                        .check_box_outline_blank),
                                                    title: Text(
                                                        getString(context)
                                                            .deactivate_forme),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      database.dataManager
                                                          .ActivateCourseFromClassForUser(
                                                              classInfo.id,
                                                              courseid,
                                                              false);
                                                    },
                                                  )
                                                : ListTile(
                                                    leading:
                                                        Icon(Icons.check_box),
                                                    title: Text(
                                                        getString(context)
                                                            .activate_forme),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      database.dataManager
                                                          .ActivateCourseFromClassForUser(
                                                              classInfo.id,
                                                              courseid,
                                                              true);
                                                    },
                                                  ),
                                            ListTile(
                                              leading: Icon(Icons.edit),
                                              title:
                                                  Text(getString(context).edit),
                                              onTap: () {
                                                Navigator.pop(context);
                                                openEditCoursePage(
                                                  context: context,
                                                  editCourseBloc: EditCourseBloc
                                                      .withEditState(
                                                    course: courseInfo,
                                                    database: database,
                                                    courseGateway:
                                                        database.courseGateway,
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.delete_sweep),
                                              title: Text(bothlang(context,
                                                  de: "Aus Klasse entfernen",
                                                  en: "Remove from class")),
                                              onTap: () {
                                                showConfirmDialog(
                                                        context: context,
                                                        title: bothlang(context,
                                                            de:
                                                                "Aus Klasse entfernen",
                                                            en:
                                                                "Remove from class"),
                                                        action:
                                                            getString(context)
                                                                .remove,
                                                        richtext: null)
                                                    .then((result) {
                                                  if (result == true) {
                                                    Navigator.pop(context);
                                                    ValueNotifier<bool>
                                                        sheet_notifier =
                                                        ValueNotifier(null);
                                                    showLoadingStateSheet(
                                                        context: context,
                                                        sheetUpdate:
                                                            sheet_notifier);
                                                    removeCourseToClass(
                                                            classid:
                                                                classInfo.id,
                                                            courseid:
                                                                courseInfo.id)
                                                        .then((result) {
                                                      sheet_notifier.value =
                                                          result;
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                        },
                                        title: courseInfo.getName(),
                                        routname: "courseid");
                                  }),
                              onTap: () {
                                pushWidget(
                                    context,
                                    CourseView(
                                      courseid: courseInfo.id,
                                      database: database,
                                    ),
                                    routname: "course");
                              },
                              enabled: isActivated,
                            );
                          },
                        );
                      }

                      if (courseInfo == null) {
                        return StreamBuilder<Course>(
                          stream: database.dataManager
                              .courseRoot(courseid)
                              .snapshots()
                              .map((doc) {
                            if (doc.exists) {
                              return Course.fromData(doc.data());
                            } else {
                              return null;
                            }
                          }),
                          builder: (context, snapshot) {
                            Course courseInfo = snapshot.data;
                            if (courseInfo == null) {
                              return LinearProgressIndicator();
                            }
                            return getListTileCourse(courseInfo);
                          },
                        );
                      }
                      return getListTileCourse(courseInfo);
                    }).toList()),
                    SizedBox(
                      height: 72.0,
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    showSheetBuilder(
                        context: context,
                        child: (context) {
                          return Flexible(
                              child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.add_circle_outline),
                                  title: Text(getString(context).createcourse),
                                  onTap: () {
                                    Navigator.pop(context);
                                    openEditCoursePage(
                                      context: context,
                                      editCourseBloc:
                                          EditCourseBloc.withCreateState(
                                        schoolClassId: classid,
                                        database: database,
                                        courseGateway: database.courseGateway,
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.widgets),
                                  title: Text(
                                      getString(context).fromexistingcourses),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pushWidget(
                                        context,
                                        SchoolClassSelectCourses(
                                            classid: classid,
                                            database: database));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.title),
                                  title: Text(getString(context).usetemplate),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pushWidget(
                                        context,
                                        SchoolClassCourseTemplatesView(
                                            classid: classid,
                                            database: database));
                                  },
                                ),
                                FormSpace(16.0),
                              ],
                            ),
                          ));
                        },
                        title: getString(context).addcourse);
                  },
                  icon: Icon(Icons.add),
                  label: Text(getString(context).addcourse)),
            ));
      },
      stream: getThreeMergedStream(
        database.schoolClassInfos.getItemStream(classid),
        database.connectionsState.connections.stream,
        database.courseinfo.stream,
      ),
    );
  }
}

class SchoolClassSelectCourses extends StatelessWidget {
  final String classid;
  final PlannerDatabase database;
  SchoolClassSelectCourses({@required this.classid, @required this.database});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TwoObjects<SchoolClass, Map<String, Course>>>(
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        SchoolClass classInfo = snapshot.data.item;
        List<Course> courses = snapshot.data.item2.values.toList()
          ..sort((it1, it2) => it1.getName().compareTo(it2.getName()));
        Design classDesign = classInfo?.getDesign();
        return Theme(
            data: newAppThemeDesign(context, classDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title: getString(context).addcoursein +
                      " " +
                      classInfo.getName()),
              body: ListView(
                children: courses.map((courseInfo) {
                  bool enablecourse =
                      !classInfo.courses.containsKey(courseInfo.id);
                  return ListTile(
                    leading: ColoredCircleText(
                        text: toShortNameLength(
                            context, courseInfo.getShortname_full()),
                        color: courseInfo.getDesign().primary,
                        radius: 22.0),
                    title: Text(courseInfo.name),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                          getString(context).teacher +
                              ": " +
                              courseInfo.getTeachersListed(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(getString(context).place +
                            ": " +
                            courseInfo.getPlacesListed()),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    isThreeLine: true,
                    enabled: enablecourse,
                    trailing: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: enablecourse
                            ? () {
                                ValueNotifier<bool> sheetnotifier =
                                    ValueNotifier(null);
                                showLoadingStateSheet(
                                    context: context,
                                    sheetUpdate: sheetnotifier);
                                addCourseToClass(
                                        courseid: courseInfo.id,
                                        classid: classid)
                                    .then((value) {
                                  sheetnotifier.value =
                                      value != null ? value : false;
                                });
                              }
                            : null),
                  );
                }).toList(),
              ),
            ));
      },
      stream: getMergedStream(database.schoolClassInfos.getItemStream(classid),
          database.courseinfo.stream),
    );
  }
}

class SchoolClassCourseTemplatesView extends StatelessWidget {
  final List<dynamic> templates = getTemplateList_DE();
  final String classid;
  final PlannerDatabase database;

  SchoolClassCourseTemplatesView(
      {@required this.database, @required this.classid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(title: getString(context).templates),
      body: StreamBuilder<TwoObjects<Map<String, Course>, SchoolClass>>(
          stream: getMergedStream(database.courseinfo.stream,
              database.schoolClassInfos.getItemStream(classid)),
          builder: (context, snapshot) {
            Map<String, Course> predata_allmycourses = snapshot.data?.item;
            SchoolClass schoolClassInfo = snapshot.data?.item2;
            if (predata_allmycourses == null || schoolClassInfo == null) {
              return CircularProgressIndicator();
            }
            List<Course> allmycourses = schoolClassInfo.courses.keys
                .map((key) => predata_allmycourses[key])
                .toList();
            allmycourses.removeWhere((it) => it == null);
            return ListView.separated(
              itemBuilder: (context, index) {
                dynamic item = templates[index];
                if (item is CourseTemplate) {
                  bool enabledtemplate = !isAlreadyaCourse(item, allmycourses);
                  return ListTile(
                    leading: ColoredCircleText(
                        text: toShortNameLength(context, item.shortname),
                        color: item.design.primary,
                        radius: 22.0),
                    title: Text(item.name),
                    trailing: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: enabledtemplate
                              ? () async {
                                  final courseGateway = CourseGateway(
                                      database.root,
                                      database.getMemberIdObject());
                                  final courseId =
                                      database.dataManager.generateCourseId();
                                  courseGateway.CreateCourseAsCreator(
                                    Course.fromTemplate(
                                        courseid: courseId, template: item),
                                  );
                                  await addCourseToClass(
                                    courseid: courseId,
                                    classid: classid,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(bothlang(context,
                                              de: "${item.name} erstellt",
                                              en: "${item.name} created."))));
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
                                      schoolClassId: classid,
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

  bool isAlreadyaCourse(CourseTemplate template, List<Course> allcourses) {
    int lowest;
    for (Course info in allcourses) {
      int levdistance = DiffMatchPatch()
          .diff_levenshtein(DiffMatchPatch().diff(template.name, info.name));
      if (lowest == null) {
        lowest = levdistance;
      } else if (lowest > levdistance) lowest = levdistance;
    }
    if ((lowest ?? 100) < 1) {
      return true;
    } else {
      return false;
    }
  }
}
