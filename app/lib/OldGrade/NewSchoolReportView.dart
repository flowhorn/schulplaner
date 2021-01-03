import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/OldGrade/SchoolReport.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

class NewSchoolReportView extends StatefulWidget {
  final PlannerDatabase database;
  final String reportid;
  final bool editmode;
  NewSchoolReportView(this.database, {this.reportid, this.editmode = false});

  @override
  State<StatefulWidget> createState() =>
      NewSchoolReportViewState(database, reportid, editmode);
}

class NewSchoolReportViewState extends State<NewSchoolReportView> {
  final PlannerDatabase database;
  bool editmode;
  String reportid;
  NewSchoolReportViewState(this.database, this.reportid, this.editmode) {
    if (editmode) {
      schoolReport = database.schoolreports.getItem(reportid);
    } else {
      schoolReport =
          SchoolReport(id: database.dataManager.schoolReportsRef.doc().id);
    }
    prefilled_name = (schoolReport.name ?? "");
  }

  SchoolReport schoolReport;

  String prefilled_name = "";

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
    ThemeData themeData = clearAppThemeData(context: context);
    return Theme(
        data: themeData,
        child: Scaffold(
          appBar: AppHeaderAdvanced(
            title: Text(editmode
                ? getString(context).editschoolreport
                : getString(context).newschoolreport),
          ),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.done),
              label: Text(getString(context).done),
              onPressed: () {
                SchoolReport newone =
                    schoolReport.copyWith(name: prefilled_name);
                if (newone.validate()) {
                  if (editmode) {
                    database.dataManager.ModifySchoolReport(newone);
                  } else {
                    database.dataManager.CreateSchoolReport(newone);
                  }
                  Navigator.pop(context);
                }
              }),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormSpace(8.0),
                FormTextField(
                  text: prefilled_name,
                  valueChanged: (newname) {
                    prefilled_name = newname;
                  },
                  labeltext: getString(context).name,
                  maxLines: 1,
                ),
                FormSpace(12.0),
                FormDivider(),
                FormSpace(72.0),
              ],
            ),
          ),
        ));
  }
}

class NewReportValueView extends StatefulWidget {
  final PlannerDatabase database;
  final SchoolReport report;
  final String courseid;
  NewReportValueView(this.database, {this.report, this.courseid});

  @override
  State<StatefulWidget> createState() =>
      NewReportValueViewiewState(database, report, courseid);
}

class NewReportValueViewiewState extends State<NewReportValueView> {
  final PlannerDatabase database;
  SchoolReport report;
  String courseid;
  String prefilled_grade = "";
  double prefilled_weight = 1.0;
  ValueNotifier<bool> showWeight = ValueNotifier(false);

  NewReportValueViewiewState(this.database, this.report, this.courseid) {
    if (report.values == null || report.values[courseid] == null) {
      reportValue = ReportValue(weight: 1.0);
    } else {
      reportValue = report.getValue(courseid);
      if (reportValue == null) reportValue = ReportValue(weight: 1.0);
    }
    prefilled_grade = reportValue.grade_key ?? "";
    prefilled_weight = reportValue.weight ?? 1.0;
    if (getGradePackage(database.getSettings().gradepackageid).inputSupport) {
      if (reportValue.grade_key != null) {
        prefilled_grade = DataUtil_Grade()
            .getGradeValueOf(reportValue.grade_key)
            .value
            .toString();
      }
    }
  }

  ReportValue reportValue;
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
    Course course = database.getCourseInfo(courseid);

    ThemeData themeData = newAppThemeDesign(context, course.getDesign());
    return Theme(
        data: themeData,
        child: Scaffold(
          appBar: MyAppHeader(
            title: course.getName(),
          ),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.done),
              label: Text(getString(context).done),
              onPressed: () {
                if (database
                    .getSettings()
                    .getCurrentGradePackage()
                    .inputSupport) {
                  try {
                    double mValue = double.parse(prefilled_grade);
                    reportValue.grade_key = database
                            .getSettings()
                            .getCurrentGradePackage()
                            .id
                            .toString() +
                        "-" +
                        mValue.toString();
                  } catch (exception) {
                    print(exception);
                  }
                }
                reportValue.weight = prefilled_weight;
                if (reportValue.validate()) {
                  database.dataManager.schoolReportsRef.doc(report.id).set(
                    {
                      'values': {
                        courseid: reportValue.toJson(),
                      },
                    },
                    SetOptions(
                      merge: true,
                    ),
                  );
                  Navigator.pop(context);
                }
              }),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormSpace(16.0),
                getGradePackage(database.getSettings().gradepackageid)
                        .inputSupport
                    ? FormTextField(
                        iconData: Icons.grade,
                        labeltext: getString(context).grade,
                        text: prefilled_grade,
                        valueChanged: (String s) {
                          prefilled_grade = s;
                        },
                        maxLines: 1,
                        keyBoardType: TextInputType.number,
                      )
                    : ListTile(
                        leading: Icon(Icons.grade),
                        title: Text(
                          getString(context).grade,
                        ),
                        subtitle: Text(reportValue.grade_key != null
                            ? DataUtil_Grade()
                                .getGradeValueOf(reportValue.grade_key)
                                .getLongName()
                            : "-"),
                        dense: false,
                        enabled: true,
                        trailing: reportValue.grade_key != null
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          showGradeValuePicker(database, context,
                              (GradeValue gradevalue) {
                            setState(() {
                              reportValue.grade_key = gradevalue.getKey();
                            });
                          }, currentid: reportValue.grade_key);
                        },
                      ),
                FormSpace(8.0),
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
                FormDivider(),
              ],
            ),
          ),
        ));
  }
}
