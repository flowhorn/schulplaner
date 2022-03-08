import 'package:decimal/decimal.dart';
import 'package:schulplaner8/OldGrade/models/school_report.dart';
import 'package:schulplaner8/models/planner_settings.dart';

import 'grade.dart';
import 'grade_value.dart';

class AverageReport {
  double? totalaverage;
  AverageReport(PlannerSettingsData settingsData, {List<ReportValue>? values}) {
    double total_value = 0.0;
    double total_weight = 0.0;

    if (values == null) {
      return;
    }

    for (ReportValue item in values) {
      final GradeValue g = DataUtil_Grade().getGradeValueOf(item.grade_key!);

      if (settingsData.weight_tendencies == false) {
        double value0 = g.value;
        final value_notendency = g.value_notendency;
        total_weight = total_weight + item.weight;
        total_value = total_value +
            ((value_notendency != null ? value_notendency : value0) *
                item.weight);
      } else {
        total_weight = total_weight + item.weight;
        total_value = total_value + g.value * item.weight;
      }
    }

    if (total_value != 0.0) {
      totalaverage = (Decimal.parse(total_value.toString()) /
              Decimal.parse(total_weight.toString()))
          .toDouble();
    }
  }
}
