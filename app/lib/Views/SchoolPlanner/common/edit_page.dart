import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class EditCourseField extends StatelessWidget {
  final PlannerDatabase database;
  final String courseID;
  final bool editmode;
  final void Function(BuildContext context, Course course) onChanged;

  const EditCourseField({
    Key? key,
    required this.database,
    required this.courseID,
    required this.editmode,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Course course = courseID != null ? database.getCourseInfo(courseID) : null;
    if (course != null) {
      return ListTile(
        leading: ColoredCircleText(
            text: toShortNameLength(context, course.getShortname_full()),
            color: course.getDesign().primary,
            radius: 20.0),
        title: Text(course.getName()),
        enabled: !editmode,
        onTap: () {
          selectCourse(context, database, courseID).then((newCourse) {
            if (newCourse != null) {
              onChanged(context, newCourse);
            }
          });
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.widgets),
        title: Text(getString(context).course),
        enabled: !editmode,
        onTap: () {
          selectCourse(context, database, courseID).then((newCourse) {
            if (newCourse != null) {
              onChanged(context, newCourse);
            }
          });
        },
      );
    }
  }
}
