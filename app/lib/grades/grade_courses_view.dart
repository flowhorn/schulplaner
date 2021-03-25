//
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/course_all_grade_view.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class GradeCoursesView extends StatelessWidget {
  final PlannerDatabase database;
  final List<Grade> list;
  final List<Course> courseList;
  final AverageCalculator calculator;

  const GradeCoursesView(
      {Key? key,
      required this.database,
      required this.list,
      required this.calculator,
      required this.courseList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpListView<Course>(
      items: courseList,
      builder: (context, course) {
        return ListTile(
          leading: ColoredCircleText(
            color: course.getDesign()?.primary,
            text: toShortNameLength(context, course.getShortname_full()),
          ),
          title: Text(course.getName()),
          onTap: () {
            pushWidget(context, CourseAllGradeView(database, course.id));
          },
          trailing: Text(
            calculator.averageperCourse[course.id]?.totalaverage != null
                ? ('Ø' +
                    database
                        .getSettings()
                        .getCurrentAverageDisplay(context: context)
                        .input(calculator
                            .averageperCourse[course.id]!.totalaverage))
                : '/',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        );
      },
      emptyViewBuilder: (context) =>
          getEmptyView(title: getString(context).nogrades),
    );
  }
}
