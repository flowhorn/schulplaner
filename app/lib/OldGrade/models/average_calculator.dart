import 'package:decimal/decimal.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/planner_settings.dart';

import 'average_course.dart';
import 'grade.dart';

class AverageCalculator {
   Map<String, AverageCourse> averageperCourse = {};
  double? totalaverage;
  AverageCalculator(PlannerSettingsData settingsData,
      {required List<Grade> grades, required List<Course> courses}) {
    double total_count = 0.0;
    double total_value = 0.0;
    courses.forEach((Course c) {
      AverageCourse courseaverage = AverageCourse(
        settingsData,
        grades: grades.where((Grade g) {
          return g.courseid == c.id;
        }).toList(),
        gradeprofileid: c.personalgradeprofile,
      );
      averageperCourse[c.id] = courseaverage;
      if (courseaverage.totalaverage != null) {
        total_count = total_count + 1;
        total_value = total_value + courseaverage.totalaverage!;
      }
    });
    if (total_count != 0.0) {
      totalaverage = (Decimal.parse(total_value.toString()) /
              Decimal.parse(total_count.toString()))
          .toDouble();
    }
  }
}
