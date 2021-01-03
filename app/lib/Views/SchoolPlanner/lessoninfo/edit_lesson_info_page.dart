import 'package:flutter/material.dart';
import 'package:schulplaner8/groups/src/models/place_link.dart';
import 'package:schulplaner8/groups/src/models/teacher_link.dart';
import 'package:schulplaner_addons/common/widgets/editpage.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Timetable.dart';
import 'package:schulplaner8/Views/SchoolPlanner/common/edit_page.dart';
import 'package:schulplaner8/models/coursepermission.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class NewLessonInfoView extends StatefulWidget {
  final PlannerDatabase database;
  final String courseid, lessonid, lessoninfoid, datestring;
  final bool editmode;

  NewLessonInfoView(
    this.database, {
    this.courseid,
    this.lessonid,
    this.lessoninfoid,
    this.datestring,
    this.editmode = false,
  });

  @override
  State<StatefulWidget> createState() => NewLessonInfoViewState(
      this.database, courseid, lessonid, editmode, lessoninfoid, datestring);
}

class NewLessonInfoViewState extends State<NewLessonInfoView> {
  final PlannerDatabase database;
  final bool editmode;
  final String courseid, lessonid, lessoninfoid, datestring;

  NewLessonInfoViewState(this.database, this.courseid, this.lessonid,
      this.editmode, this.lessoninfoid, this.datestring) {
    if (editmode) {
      lessoninfo = database.lessoninfos.getItem(lessoninfoid);
    } else {
      if (courseid == null) {
        lessoninfo = LessonInfo(type: LessonInfoType.NONE, date: datestring);
      } else {
        if (lessonid == null) {
          lessoninfo = LessonInfo(
              id: database.dataManager
                  .getLessonInfoRefCourse(courseid)
                  .doc()
                  .id,
              courseid: courseid,
              date: datestring,
              type: LessonInfoType.NONE);
        } else {
          lessoninfo = LessonInfo(
              id: database.dataManager
                  .getLessonInfoRefCourse(courseid)
                  .doc()
                  .id,
              courseid: courseid,
              lessonid: lessonid,
              date: datestring,
              type: LessonInfoType.NONE);
        }
      }
      ;
    }
    prefilled_detail = lessoninfo.note ?? "";
  }

  LessonInfo lessoninfo;

  String prefilled_detail = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    if (lessoninfo.courseid != null) {
      themeData = newAppThemeDesign(
          context, database.getCourseInfo(lessoninfo.courseid)?.getDesign());
    } else {
      themeData = clearAppThemeData(context: context);
    }
    Lesson lesson;
    if (lessoninfo.lessonid != null && lessoninfo.courseid != null) {
      lesson = database.getLessons()[lessoninfo.lessonid];
    }

    return Theme(
        data: themeData,
        child: Scaffold(
          appBar: AppHeaderAdvanced(
            title: Text(editmode
                ? getString(context).editlessoninfo
                : getString(context).newlessoninfo),
            actions: <Widget>[
              editmode
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: getString(context).delete,
                      onPressed: () {
                        requestPermission().then((result) {
                          if (result) {
                            database.dataManager.DeleteLessonInfo(lessoninfo);
                            Future.delayed(Duration(milliseconds: 500))
                                .then((_) {
                              Navigator.pop(context);
                            });
                          } else {
                            var sheet =
                                showPermissionStateSheet(context: context);
                            sheet.value = false;
                          }
                        });
                      })
                  : nowidget()
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.done),
              label: Text(getString(context).done),
              onPressed: () {
                LessonInfo newone =
                    lessoninfo.copy(note: prefilled_detail.toString());
                if (newone.validate()) {
                  requestPermission().then((result) {
                    if (result) {
                      if (editmode) {
                        database.dataManager.ModifyLessonInfo(newone);
                      } else {
                        database.dataManager.CreateLessonInfo(newone);
                      }

                      Future.delayed(Duration(milliseconds: 500)).then((_) {
                        Navigator.pop(context);
                      });
                    } else {
                      var sheet = showPermissionStateSheet(context: context);
                      sheet.value = false;
                    }
                  });
                } else {
                  final infoDialog = InfoDialog(
                    title: getString(context).failed,
                    message: getString(context).pleasecheckdata,
                  );
                  // ignore: unawaited_futures
                  infoDialog.show(context);
                }
              }),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                EditCourseField(
                  courseID: lessoninfo.courseid,
                  database: database,
                  editmode: !course_selectable(),
                  onChanged: (context, newCourse) {
                    setState(() {
                      lessoninfo = lessoninfo.copy(
                        courseid: newCourse.id,
                      );
                    });
                  },
                ),
                FormDivider(),
                EditDateField(
                  label: getString(context).date,
                  date: lessoninfo.date,
                  onChanged: (newDate) {
                    setState(() {
                      lessoninfo = lessoninfo.copy(date: newDate);
                    });
                  },
                ),
                FormDivider(),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text(
                    getString(context).type +
                        ": " +
                        (getLessonInfoTypes(context)[lessoninfo.type.index]
                                .name ??
                            "-"),
                  ),
                  trailing: Icon(
                      getLessonInfoTypes(context)[lessoninfo.type.index]
                          .iconData),
                  onTap: () {
                    showLessonInfotypePicker(database, context, (int mType) {
                      setState(
                          () => lessoninfo.type = LessonInfoType.values[mType]);
                    }, currentid: lessoninfo.type.index);
                  },
                ),
                FormDivider(),
                EditCustomField(
                  value: (lesson != null
                      ? (getWeekDays(context)[lesson.day].name +
                          ", " +
                          (lesson.isMultiLesson()
                              ? lesson.start.toString() +
                                  ". - " +
                                  lesson.end.toString() +
                                  ". "
                              : lesson.start.toString() + ". "))
                      : null),
                  onClicked: (context) {
                    if (lessoninfo.courseid != null) {
                      return showLessonPicker(
                              database, context, lessoninfo.courseid,
                              currentid: lessoninfo.lessonid)
                          .then((newLesson) {
                        if (newLesson != null) {
                          setState(
                              () => lessoninfo.lessonid = newLesson.lessonid);
                        }
                      });
                    } else {
                      showResultStateSheet(context: context).value = ResultItem(
                        text: bothlang(context,
                            de: "Du musst vorher einen Kurs auswählen!",
                            en: "You have to select a course!"),
                        iconData: Icons.warning,
                        loading: false,
                        color: Colors.orange,
                      );
                      return Future.value(false);
                    }
                  },
                  label: getString(context).lesson,
                  iconData: Icons.today,
                ),
                FormDivider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(getString(context).teacher),
                  subtitle: Text(lessoninfo.teacher?.name ?? "-"),
                  onTap: () {
                    selectTeacher(
                            context,
                            database,
                            singleToMap(lessoninfo.teacher,
                                lessoninfo.teacher?.teacherid))
                        .then((newteacher) {
                      setState(() => lessoninfo = lessoninfo.copy(
                          teacher: TeacherLink.fromTeacher(newteacher)));
                    });
                  },
                  enabled: lessoninfo.type == LessonInfoType.CHANGED,
                ),
                FormDivider(),
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text(getString(context).place),
                  subtitle: Text(lessoninfo.place?.name ?? "-"),
                  onTap: () {
                    selectPlace(
                            context,
                            database,
                            singleToMap(
                                lessoninfo.place, lessoninfo.place?.placeid))
                        .then((newplace) {
                      setState(() => lessoninfo = lessoninfo.copy(
                          place: PlaceLink.fromPlace(newplace)));
                    });
                  },
                  enabled: lessoninfo.type == LessonInfoType.CHANGED,
                ),
                FormDivider(),
                EditTextField(
                  initialValue: prefilled_detail,
                  iconData: Icons.note,
                  onChanged: (newText) {
                    prefilled_detail = newText;
                  },
                  label: getString(context).note,
                  maxLines: null,
                ),
                FormDivider(),
                FormSpace(72.0),
              ],
            ),
          ),
        ));
  }

  bool course_selectable() {
    if (courseid != null) return false;
    if (editmode) return false;
    return true;
  }

  Future<bool> requestPermission() {
    if (lessoninfo.courseid != null) {
      return requestPermissionCourse(
          database: database,
          category: PermissionAccessType.creator,
          courseid: lessoninfo.courseid);
    } else {
      throw Exception("SOMETHING WENT WRONG???");
    }
  }
}

Future<Lesson> showLessonPicker(
    PlannerDatabase database, BuildContext context, String courseid,
    {String currentid}) {
  List<Lesson> mylist = database
      .getLessons()
      .values
      .where((Lesson l) => l.courseid == courseid)
      .toList();
  return selectItem<Lesson>(
      context: context,
      items: mylist,
      builder: (context, item) {
        return ListTile(
            title: Text((getWeekDays(context)[item.day].name +
                ", " +
                (item.isMultiLesson()
                    ? item.start.toString() +
                        ". - " +
                        item.end.toString() +
                        ". "
                    : item.start.toString() + ". "))),
            onTap: () {
              Navigator.pop(context, item);
            },
            trailing: currentid == item.lessonid
                ? Icon(Icons.done, color: Colors.green)
                : null);
      });
}

void showLessonInfotypePicker(
    PlannerDatabase database, BuildContext context, ValueSetter<int> onTapData,
    {int currentid}) {
  List<Choice> mylist = [];
  mylist..addAll(getLessonInfoTypes(context));
  selectItem<Choice>(
      context: context,
      items: mylist,
      builder: (context, item) {
        return ListTile(
            leading: Icon(item.iconData),
            title: Text(item.name),
            onTap: () {
              onTapData(item.id);
              Navigator.pop(context);
            },
            trailing: currentid == item.id
                ? Icon(Icons.done, color: Colors.green)
                : null);
      });
}
