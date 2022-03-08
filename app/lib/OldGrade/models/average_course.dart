import 'package:decimal/decimal.dart';
import 'package:schulplaner8/grades/models/grade_profile.dart';
import 'package:schulplaner8/grades/models/grade_type.dart';
import 'package:schulplaner8/grades/models/grade_type_item.dart';
import 'package:schulplaner8/models/planner_settings.dart';

import 'grade.dart';

class AverageCourse {
  late Map<GradeTypeItem, double> averageperType;
  double? totalaverage;
  double weight_schoolreport = 1.0;
  AverageCourse(PlannerSettingsData settingsData,
      {required List<Grade> grades, String? gradeprofileid}) {
    averageperType = {};
    double total_value = 0.0;
    double total_weight = 0.0;
    GradeProfile gradeProfile = settingsData.getGradeProfile(gradeprofileid);
    weight_schoolreport = gradeProfile.weight_totalaverage;

    if (!gradeProfile.averagebytype) {
      grades.forEach((Grade g) {
        if (settingsData == null) {
          total_weight = total_weight + g.weight;
          total_value = total_value +
              (DataUtil_Grade().getGradeValueOf(g.valuekey!).value * g.weight);
        } else {
          if (settingsData.weight_tendencies == false) {
            double value0 = DataUtil_Grade().getGradeValueOf(g.valuekey!).value;
            double? value_notendency =
                DataUtil_Grade().getGradeValueOf(g.valuekey!).value_notendency;
            total_weight = total_weight + g.weight;
            total_value = total_value +
                ((value_notendency != null ? value_notendency : value0) *
                    g.weight);
          } else {
            total_weight = total_weight + g.weight;
            total_value = total_value +
                (DataUtil_Grade().getGradeValueOf(g.valuekey!).value *
                    g.weight);
          }
        }
      });
    } else {
      for (GradeTypeItem? mTypeItem in gradeProfile.types.values) {
        double eachtype_total_value = 0.0;
        double eachtype_total_weight = 0.0;
        List<Grade> eachtype_grades = grades.where((Grade g) {
          return mTypeItem!.isValidGrade(g);
        }).toList();
        if (eachtype_grades.length != null) {
          eachtype_grades.forEach((Grade g) {
            if (settingsData == null) {
              eachtype_total_weight = eachtype_total_weight + g.weight;
              eachtype_total_value = eachtype_total_value +
                  (DataUtil_Grade().getGradeValueOf(g.valuekey!).value *
                      g.weight);
            } else {
              if (settingsData.weight_tendencies == false) {
                final value0 =
                    DataUtil_Grade().getGradeValueOf(g.valuekey!).value;
                final value_notendency = DataUtil_Grade()
                    .getGradeValueOf(g.valuekey!)
                    .value_notendency;
                eachtype_total_weight = eachtype_total_weight + g.weight;
                eachtype_total_value = eachtype_total_value +
                    ((value_notendency != null ? value_notendency : value0) *
                        g.weight);
              } else {
                eachtype_total_weight = eachtype_total_weight + g.weight;
                eachtype_total_value = eachtype_total_value +
                    (DataUtil_Grade().getGradeValueOf(g.valuekey!).value *
                        g.weight);
              }
            }
          });
          if (mTypeItem!.testsasoneexam == true) {
            Iterable<Grade> grades_test =
                grades.where((it) => it.type == GradeType.TEST);
            double typetest_total_value = 0.0;
            double typetest_total_weight = 0.0;
            grades_test.forEach((Grade g) {
              if (settingsData == null) {
                typetest_total_weight = typetest_total_weight + g.weight;
                typetest_total_value = typetest_total_value +
                    (DataUtil_Grade().getGradeValueOf(g.valuekey!).value *
                        g.weight);
              } else {
                if (settingsData.weight_tendencies == false) {
                  final value0 =
                      DataUtil_Grade().getGradeValueOf(g.valuekey!).value;
                  final value_notendency = DataUtil_Grade()
                      .getGradeValueOf(g.valuekey!)
                      .value_notendency;
                  typetest_total_weight = typetest_total_weight + g.weight;
                  typetest_total_value = typetest_total_value +
                      ((value_notendency != null ? value_notendency : value0) *
                          g.weight);
                } else {
                  typetest_total_weight = typetest_total_weight + g.weight;
                  typetest_total_value = typetest_total_value +
                      (DataUtil_Grade().getGradeValueOf(g.valuekey!).value *
                          g.weight);
                }
              }
            });

            if (typetest_total_weight != 0) {
              Decimal average_oftypetest =
                  (Decimal.parse(typetest_total_value.toString()) /
                          Decimal.parse(typetest_total_weight.toString()))
                      .toDecimal();
              eachtype_total_weight = eachtype_total_weight + 1.0;
              eachtype_total_value =
                  eachtype_total_value + average_oftypetest.toDouble();
            }
          }
          if (eachtype_total_weight != 0.0) {
            Decimal type_average =
                (Decimal.parse(eachtype_total_value.toString()) /
                        Decimal.parse(eachtype_total_weight.toString()))
                    .toDecimal();
            averageperType[mTypeItem] = type_average.toDouble();

            total_value =
                total_value + (averageperType[mTypeItem]! * mTypeItem.weight);
            total_weight = total_weight + mTypeItem.weight;
          }
        }
      }
    }

    if (total_weight != 0.0) {
      totalaverage = (Decimal.parse(total_value.toString()) /
              Decimal.parse(total_weight.toString()))
          .toDouble();
    }
  }
}
