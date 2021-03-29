//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

import 'Grade.dart';
import 'GradeDetail.dart';

class CourseAllGradeView extends StatefulWidget {
  final String courseid;
  final PlannerDatabase database;

  CourseAllGradeView(this.database, this.courseid);

  @override
  State<StatefulWidget> createState() =>
      CourseAllGradeViewState(database, courseid);
}

class CourseAllGradeViewState extends State<CourseAllGradeView> {
  late String courseid;
  late Course? item;
  late StreamSubscription<Course?> datalistener;
  late StreamSubscription<List<Grade>?> datalistener_grade;
  final PlannerDatabase database;

  CourseAllGradeViewState(this.database, this.courseid) {
    list = (database.grades.data ?? [])
        .where((grade) => grade.courseid == courseid)
        .toList()
          ..sort((g1, g2) {
            return g1.date!.compareTo(g2.date!);
          });
    calculator = AverageCourse(database.getSettings(),
        grades: list,
        gradeprofileid:
            database.getCourseInfo(courseid)!.personalgradeprofile!);
  }

  List<Grade> list = [];
  late AverageCourse calculator;

  void _newCalculation() {
    calculator = AverageCourse(database.getSettings(),
        grades: list,
        gradeprofileid:
            database.getCourseInfo(courseid)!.personalgradeprofile!);
  }

  @override
  void initState() {
    datalistener =
        database.courseinfo.getItemStream(courseid).listen((newcourseinfo) {
      setState(() {
        item = newcourseinfo;
      });
    });
    datalistener_grade = database.grades.stream.listen((newlist) {
      setState(() {
        list = newlist.where((grade) => grade.courseid == courseid).toList()
          ..sort((g1, g2) {
            return g1.date!.compareTo(g2.date!);
          });
        _newCalculation();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    datalistener.cancel();
    datalistener_grade.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: newAppThemeDesign(context, item?.getDesign()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            item?.getName() ?? '-',
          ),
          bottom: PreferredSize(
            child: Container(
              height: 50.0,
              child: ListTile(
                title: Text(getString(context).average + ':'),
                trailing: Text(
                  'Ø' +
                      (calculator.totalaverage != null
                          ? database
                              .getSettings()
                              .getCurrentAverageDisplay(context: context)
                              .input(calculator.totalaverage)
                          : '/'),
                  style: TextStyle(
                      color: getTextColor(item?.getDesign()?.primary),
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
              ),
            ),
            preferredSize: Size(double.infinity, 50.0),
          ),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            final grade = list[position];
            return Column(children: <Widget>[
              Divider(
                height: 1.0,
              ),
              ListTile(
                onTap: () {
                  showGradeInfoSheet(database,
                      context: context, gradeid: grade.id!);
                },
                leading: ColoredCircleText(
                  color: item?.getDesign()?.primary,
                  text: toShortNameLength(context, item?.getShortname_full()),
                ),
                title: Text(grade.title!),
                subtitle: Column(
                  children: <Widget>[
                    Text(getDateText(grade.date!)),
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                isThreeLine: false,
                trailing: Text(
                  DataUtil_Grade().getGradeValueOf(grade.valuekey!).name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              )
            ]);
          },
        ),
        floatingActionButton: _Fab(courseId: courseid),
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  final String courseId;

  const _Fab({Key? key, required this.courseId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return FloatingActionButton.extended(
      onPressed: () {
        pushWidget(
            context,
            NewGradeView(
              database,
              courseid: courseId,
            ));
      },
      label: Text(getString(context).newgrade),
      icon: Icon(Icons.add),
    );
  }
}
