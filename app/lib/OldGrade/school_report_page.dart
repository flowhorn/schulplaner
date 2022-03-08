import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/models/school_report.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:share/share.dart';

import 'NewSchoolReportView.dart';
import 'models/average_report.dart';
import 'models/grade.dart';

Future<void> openSchoolReportPage(
    {required BuildContext context, required String reportId}) async {
  await pushWidget(
    context,
    SchoolReportPage(
      reportId: reportId,
    ),
  );
}

class SchoolReportPage extends StatelessWidget {
  final String reportId;
  const SchoolReportPage({Key? key, required this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    final courses = database.getCourseList();
    return StreamBuilder<SchoolReport?>(
        stream: database.schoolreports.getItemStream(reportId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final report = snapshot.data!;

          final valuesList = report.values.values.toList();

          final AverageReport averageReport = AverageReport(
            database.getSettings(),
            values: valuesList,
          );
          return Scaffold(
            appBar: _AppBar(
              myreport: report,
              courses: courses,
              averageReport: averageReport,
            ),
            body: _Body(
              myreport: report,
              courses: courses,
              averageReport: averageReport,
            ),
          );
        });
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final SchoolReport myreport;
  final AverageReport averageReport;
  final List<Course> courses;
  const _AppBar({
    Key? key,
    required this.myreport,
    required this.averageReport,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return AppBar(
      title: Text(getString(context).schoolreport),
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, 50.0),
        child: Container(
          height: 50.0,
          child: ListTile(
            title: Text(
              myreport.name,
              style: TextStyle(color: getTextColor(getPrimaryColor(context))),
            ),
            leading: Icon(
              Icons.assignment,
              color: getTextColor(getPrimaryColor(context)),
            ),
            trailing: Text(
              'Ø' +
                  (averageReport.totalaverage != null
                      ? database
                          .getSettings()
                          .getCurrentAverageDisplay(context: context)
                          .input(averageReport.totalaverage!)
                      : '/'),
              style: TextStyle(
                  color: getTextColor(getPrimaryColor(context)),
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            String firstpart = (myreport.name) +
                ': \n ' +
                getString(context).average +
                ': ' +
                database
                    .getSettings()
                    .getCurrentAverageDisplay(context: context)
                    .input(averageReport.totalaverage!)
                    .toString() +
                '\n';
            for (Course c in courses) {
              firstpart = firstpart +
                  c.name +
                  ': ' +
                  (myreport.getValue(c.id)?.grade_key != null
                      ? (DataUtil_Grade()
                          .getGradeValueOf(myreport.getValue(c.id)!.grade_key!)
                          .name)
                      : '/') +
                  '\n';
            }
            Share.share(firstpart);
          },
          tooltip: getString(context).share,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 100.0);
}

class _Body extends StatelessWidget {
  final SchoolReport myreport;
  final AverageReport averageReport;
  final List<Course> courses;
  const _Body({
    Key? key,
    required this.myreport,
    required this.averageReport,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        Course course = courses[index];
        return ListTile(
          leading: ColoredCircleText(
            text: toShortNameLength(context, course.getShortname_full()),
            color: course.getDesign()?.primary,
          ),
          title: Text(course.getName()),
          onTap: () {
            pushWidget(
                context,
                NewReportValueView(
                  database,
                  report: myreport,
                  courseid: course.id,
                ));
          },
          trailing: Text(
            myreport.getValue(course.id)?.grade_key != null
                ? (DataUtil_Grade()
                    .getGradeValueOf(myreport.getValue(course.id)!.grade_key!)
                    .name)
                : '/',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        );
      },
    );
  }
}
