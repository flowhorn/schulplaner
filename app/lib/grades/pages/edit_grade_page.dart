//
import 'package:flutter/material.dart';
import 'package:schulplaner8/OldGrade/models/choice.dart';
import 'package:schulplaner8/OldGrade/models/grade.dart';
import 'package:schulplaner8/OldGrade/models/grade_value.dart';
import 'package:schulplaner8/grades/models/grade_type.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_addons/common/widgets/editpage.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';

import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyTasks.dart';
import 'package:schulplaner8/Views/SchoolPlanner/common/edit_page.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class NewGradeView extends StatefulWidget {
  final PlannerDatabase database;
  final String? courseid, gradeid;
  final String? date;
  final bool editmode;
  NewGradeView(this.database,
      {this.courseid, this.date, this.gradeid, this.editmode = false});

  @override
  State<StatefulWidget> createState() =>
      NewGradeViewState(database, courseid, gradeid, editmode, date);
}

class NewGradeViewState extends State<NewGradeView> {
  final PlannerDatabase database;
  late bool editmode;
  late String? courseid, gradeid;
  ValueNotifier<bool> showWeight = ValueNotifier(false);
  NewGradeViewState(
      this.database, this.courseid, this.gradeid, this.editmode, String? date) {
    if (editmode) {
      grade = database.grades.getItem(gradeid!)!;
    } else {
      grade = Grade(
        id: database.dataManager.gradesRef.doc().id,
        courseid: courseid,
        type: GradeType.EXAM,
        date: date!,
      );
    }
    prefilled_title = grade.title ?? '';
    prefilled_weight = grade.weight;
    if (getGradePackage(database.getSettings().gradepackageid).inputSupport) {
      if (grade.valuekey != null) {
        prefilled_grade =
            DataUtil_Grade().getGradeValueOf(grade.valuekey!).value.toString();
      }
    }
  }
  late Grade grade;

  String prefilled_title = '';
  String prefilled_grade = '';
  double prefilled_weight = 1.0;
  bool correct_double = true;

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
    ThemeData themeData = getLessonTheme(context);
    return Theme(
        data: themeData,
        child: Scaffold(
          appBar: MyAppHeader(
              title: editmode
                  ? getString(context).editgrade
                  : getString(context).newgrade),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.done),
              label: Text(getString(context).done),
              onPressed: () {
                if (database
                    .getSettings()
                    .getCurrentGradePackage()
                    .inputSupport) {
                  Grade newone = grade.copy(
                      title: prefilled_title, weight: prefilled_weight);
                  try {
                    double mValue = double.parse(prefilled_grade);
                    newone = newone.copy(
                        valuekey: database
                                .getSettings()
                                .getCurrentGradePackage()
                                .id
                                .toString() +
                            '-' +
                            mValue.toString());
                    if (newone.isValid() &&
                        newone.validate() &&
                        correct_double) {
                      if (editmode) {
                        database.dataManager.ModifyGrade(newone);
                      } else {
                        database.dataManager.CreateGrade(newone);
                      }
                      Navigator.pop(context);
                    }
                  } catch (exception) {
                    //do nothing.
                  }
                } else {
                  Grade newone = grade.copy(
                      title: prefilled_title, weight: prefilled_weight);
                  if (newone.isValid() && newone.validate() && correct_double) {
                    if (editmode) {
                      database.dataManager.ModifyGrade(newone);
                    } else {
                      database.dataManager.CreateGrade(newone);
                    }
                    Navigator.pop(context);
                  }
                }
              }),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormSpace(8.0),
                FormTextField(
                  text: prefilled_title,
                  valueChanged: (newtext) {
                    prefilled_title = newtext;
                  },
                  labeltext: getString(context).title,
                  maxLines: 1,
                  maxLengthEnforced: true,
                  maxLength: 52,
                ),
                FormDivider(),
                EditCourseField(
                  editmode: editmode,
                  courseId: grade.courseid,
                  onChanged: (context, newCourse) {
                    setState(() {
                      grade = grade.copy(courseid: newCourse.id);
                    });
                  },
                ),
                FormDivider(),
                getGradePackage(database.getSettings().gradepackageid)
                        .inputSupport
                    ? FormTextField(
                        iconData: Icons.grade,
                        text: prefilled_grade,
                        valueChanged: (String s) {
                          prefilled_grade = s.replaceAll(',', '.');
                        },
                        maxLines: 1,
                        keyBoardType: TextInputType.number,
                      )
                    : ListTile(
                        leading: Icon(Icons.grade),
                        title: Text(
                          getString(context).grade +
                              ': ' +
                              (grade.valuekey != null
                                  ? DataUtil_Grade()
                                      .getGradeValueOf(grade.valuekey!)
                                      .getLongName()
                                  : '-'),
                        ),
                        enabled: true,
                        trailing: grade.valuekey != null
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          showGradeValuePicker(database, context,
                              (GradeValue gradevalue) {
                            setState(() {
                              grade = grade.copy(valuekey: gradevalue.getKey());
                            });
                          }, currentid: grade.valuekey);
                        },
                      ),
                FormDivider(),
                Column(
                  children: <Widget>[
                    EditDateField(
                      date: grade.date,
                      label: getString(context).date,
                      onChanged: (newDate) {
                        setState(() {
                          grade = grade.copy(date: newDate);
                        });
                      },
                    ),
                    SingleChildScrollView(
                      child: ButtonBar(
                        children:
                            (getRecommendedDatesSimple(context)).map((rec) {
                          return RButton(
                              text: rec.text,
                              onTap: () {
                                setState(() {
                                  grade = grade.copy(date: rec.date);
                                });
                              },
                              enabled: rec.date != grade.date,
                              disabledColor: Colors.green,
                              iconData:
                                  rec.date == grade.date ? Icons.done : null);
                        }).toList(),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ],
                ),
                FormDivider(),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text(
                    getString(context).type,
                  ),
                  subtitle: Text(getGradeTypes(context)[grade.type.index].name),
                  dense: false,
                  trailing:
                      Icon(getGradeTypes(context)[grade.type.index].iconData),
                  onTap: () {
                    showGradetypePicker(database, context, (int mType) {
                      setState(() => grade.type = GradeType.values[mType]);
                    }, currentid: grade.type.index);
                  },
                ),
                FormDivider(),
                FormHideable(
                    title: getString(context).weight,
                    notifier: showWeight,
                    builder: (context) {
                      return FormTextField(
                        iconData: Icons.line_weight,
                        labeltext: getString(context).weight,
                        text: prefilled_weight.toString(),
                        valueChanged: (String s) {
                          try {
                            double possibledouble = double.parse(s);
                            prefilled_weight = possibledouble;
                            correct_double = true;
                          } catch (exception) {
                            correct_double = false;
                          }
                        },
                        keyBoardType: TextInputType.numberWithOptions(),
                        maxLines: 1,
                      );
                    }),
                FormSpace(72.0),
              ],
            ),
          ),
        ));
  }

  ThemeData getLessonTheme(BuildContext context) {
    if (grade.courseid != null) {
      return newAppThemeDesign(
          context, database.courseinfo.data[grade.courseid]?.getDesign());
    } else {
      return clearAppThemeData(context: context);
    }
  }

  List<RecommendedDate> getRecommendedDatesSimple(BuildContext context) {
    return [
      RecommendedDate(text: getString(context).today, date: getDateToday()),
      RecommendedDate(
          text: getString(context).tomorrow, date: getDateTomorrow()),
    ];
  }

  bool course_selectable() {
    if (courseid != null) return false;
    return true;
  }
}

const formPaddingText =
    EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0);

void showGradeValuePicker(PlannerDatabase database, BuildContext context,
    ValueSetter<GradeValue> onTapData,
    {String? currentid}) {
  PlannerSettingsData settings = database.getSettings();
  selectItem<GradeValue>(
      context: context,
      items: getGradePackage(settings.gradepackageid, context: context)
          .gradevalues,
      builder: (context, item) {
        return ListTile(
            leading: Icon(Icons.grade),
            title: Text(item.getLongName()),
            onTap: () {
              onTapData(item);
              Navigator.pop(context);
            },
            trailing: currentid == item.id
                ? Icon(Icons.done, color: Colors.green)
                : null);
      });
}

void showGradetypePicker(
    PlannerDatabase database, BuildContext context, ValueSetter<int> onTapData,
    {int? currentid}) {
  List<Choice> mylist = [];
  mylist..addAll(getGradeTypes(context));
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
    },
  );
}
