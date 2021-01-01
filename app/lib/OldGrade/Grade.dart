import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/OldGrade/SchoolReport.dart';
import 'package:schulplaner8/grades/models/grade_profile.dart';
import 'package:schulplaner8/grades/models/grade_type.dart';
import 'package:schulplaner8/grades/models/grade_type_item.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

typedef GradeValue GetGradeValue(String gradevalueid);

class Choice {
  dynamic id;
  String name;
  IconData iconData;

  Choice(this.id, this.name, {this.iconData});
}

List<Choice> getGradeTypes(BuildContext context) {
  return [
    Choice(0, getString(context).task, iconData: Icons.class_),
    Choice(1, getString(context).exam, iconData: Icons.class_),
    Choice(2, getString(context).oralexam, iconData: Icons.speaker),
    Choice(3, getString(context).test, iconData: Icons.text_fields),
    Choice(4, getString(context).other, iconData: Icons.all_out),
    Choice(5, getString(context).generalparticipation,
        iconData: Icons.pan_tool),
  ];
}

class Grade {
  Grade({
    this.id,
    this.courseid,
    this.title,
    this.date,
    this.valuekey,
    this.weight,
    this.type,
  });

  String id, courseid, title, date, valuekey;
  double weight;
  GradeType type;

  Grade copy(
      {String id,
      String courseid,
      String title,
      String date,
      String valuekey,
      String sectionid,
      double weight,
      int type}) {
    return Grade(
      id: id ?? this.id,
      courseid: courseid ?? this.courseid,
      title: title ?? this.title,
      date: date ?? this.date,
      valuekey: valuekey ?? this.valuekey,
      weight: weight ?? this.weight,
      type: type ?? this.type,
    );
  }

  String getKey() => courseid + "--" + id;

  Grade.fromData(Map<String, dynamic> data) {
    id = data["gradeid"] ?? data["id"];
    courseid = data["courseid"] ?? data['coursid'];
    title = data["title"] ?? data["name"];
    date = data["date"];
    valuekey = data["valueid"];

    weight = double.parse(data["weight"].toString());
    type = GradeType.values[data['type'] - 1];
  }

  Map<String, Object> toJson() {
    return {
      "gradeid": id,
      "courseid": courseid,
      "title": title,
      "date": date,
      "valueid": valuekey,
      "weight": weight,
      "type": type.index + 1,
    };
  }

  bool isValid() {
    return id != null;
  }

  bool validate() {
    if (id == null || id == "") return false;
    if (courseid == null || courseid == "") return false;
    if (date == null || date == "") return false;
    if (title == null || title == "") return false;
    if (weight == null) return false;
    if (valuekey == null || valuekey == "") return false;
    return true;
  }
}

class DataUtil_Grade {
  String getKey(Grade item) => item.getKey();

  static String getKeyBy(String courseid, String gradeid) {
    return courseid + "--" + gradeid;
  }

  int sort(Grade item1, Grade item2) {
    return item1.date.compareTo(item2.date);
  }

  GradeValue getGradeValueOf(String gradevaluekey) {
    return getGradePackageOf(gradevaluekey).getGradeValue(gradevaluekey);
  }

  GradePackage getGradePackageOf(String gradevaluekey) {
    return getGradePackage(int.parse(gradevaluekey.split("-")[0]));
  }
}

class GradeValue {
  final String id, name, name2;
  final int gradepackage;
  final double value, value_notendency;
  const GradeValue(
      {this.id,
      this.name,
      this.name2,
      this.gradepackage,
      this.value,
      this.value_notendency});

  String getLongName() {
    if (name2 == null) {
      return name;
    } else {
      return name + " (${name2})";
    }
  }

  String getKey() {
    return id;
  }
}

typedef String AverageInput(double value);

class AverageDisplay {
  AverageInput input;
  String name;
  AverageDisplay(this.input, {this.name = "Standard"});

  String getAverageString(double value) {
    return input(value);
  }
}

class AverageSettings {
  bool automatic;
  Map<GradeType, double> weightperType;
  AverageSettings({this.automatic = true, this.weightperType}) {
    if (weightperType == null) {
      this.weightperType = {
        GradeType.HOMEWORK: 1.0,
        GradeType.EXAM: 1.0,
        GradeType.ORALEXAM: 1.0,
        GradeType.TEST: 1.0,
        GradeType.OTHER: 1.0,
        GradeType.GENERAL_PARTICIPATION: 1.0,
      };
    }
  }
  AverageSettings.fromJson(dynamic json) {
    automatic = json != null ? json["automatic"] : true;
    List<dynamic> weightlist = json != null ? json["weightpertype"] : null;
    if (weightlist != null) {
      weightperType = weightlist.asMap().map((int key, dynamic value) {
        return MapEntry<GradeType, double>(
            GradeType.values[int.parse(value.split("-")[0])],
            double.parse(value.split("-")[1]));
      });
    } else {
      weightperType = {
        GradeType.HOMEWORK: 1.0,
        GradeType.EXAM: 1.0,
        GradeType.ORALEXAM: 1.0,
        GradeType.TEST: 1.0,
        GradeType.OTHER: 1.0,
        GradeType.GENERAL_PARTICIPATION: 1.0,
      };
    }
  }

  Map<String, Object> toJson() {
    return {
      "automatic": automatic,
      "weightpertype":
          weightperType.entries.map((MapEntry<GradeType, double> entry) {
        return entry.key.index.toString() + "-" + entry.value.toString();
      }).toList(),
    };
  }
}

class AppWidgetSettings {
  final bool darkmode;

  const AppWidgetSettings({
    @required this.darkmode,
  });

  factory AppWidgetSettings.fromData(dynamic data) {
    return AppWidgetSettings(
      darkmode: data['darkmode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkmode': darkmode,
    };
  }

  AppWidgetSettings copyWith({
    bool darkmode,
  }) {
    return AppWidgetSettings(
      darkmode: darkmode ?? this.darkmode,
    );
  }
}

class GradeSpan {
  final String id, start, end, name;
  final bool activated;

  const GradeSpan({
    @required this.id,
    @required this.start,
    @required this.end,
    @required this.name,
    @required this.activated,
  });

  factory GradeSpan.fromData(Map<String, dynamic> data) {
    return GradeSpan(
      id: data['id'],
      start: data['start'],
      end: data['end'],
      name: data['name'] ?? "-",
      activated: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start,
      'end': end,
      'name': name,
    };
  }

  String getName(BuildContext context) {
    if (id == "custom") {
      return getString(context).custom;
    } else if (id == "full") {
      return getString(context).wholetimespan;
    } else {
      return name;
    }
  }

  GradeSpan copyWith({
    String id,
    String start,
    String end,
    String name,
    bool activated,
  }) {
    return GradeSpan(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      activated: activated ?? this.activated,
    );
  }

  String getStartText(BuildContext context) {
    if (start == null) {
      return getString(context).open;
    } else {
      return getDateTextShort2(start);
    }
  }

  String getEndText(BuildContext context) {
    if (end == null) {
      return getString(context).open;
    } else {
      return getDateTextShort2(end);
    }
  }
}

class AverageCalculator {
  Map<String, AverageCourse> averageperCourse;
  double totalaverage;
  AverageCalculator(PlannerSettingsData settingsData,
      {List<Grade> grades, List<Course> courses}) {
    averageperCourse = Map();
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
        total_value = total_value + courseaverage.totalaverage;
      }
    });
    if (total_count != 0.0) {
      totalaverage = (Decimal.parse(total_value.toString()) /
              Decimal.parse(total_count.toString()))
          .toDouble();
    }
  }
}

class AverageCourse {
  Map<GradeTypeItem, double> averageperType;
  double totalaverage;
  double weight_schoolreport = 1.0;
  AverageCourse(PlannerSettingsData settingsData,
      {List<Grade> grades, String gradeprofileid}) {
    averageperType = Map();
    double total_value = 0.0;
    double total_weight = 0.0;
    GradeProfile gradeProfile = settingsData.getGradeProfile(gradeprofileid);
    weight_schoolreport = gradeProfile.weight_totalaverage;

    if (!gradeProfile.averagebytype) {
      grades.forEach((Grade g) {
        if (settingsData == null) {
          total_weight = total_weight + g.weight;
          total_value = total_value +
              (DataUtil_Grade().getGradeValueOf(g.valuekey).value * g.weight);
        } else {
          if (settingsData.weight_tendencies == false) {
            double value0 = DataUtil_Grade().getGradeValueOf(g.valuekey).value;
            double value_notendency =
                DataUtil_Grade().getGradeValueOf(g.valuekey).value_notendency;
            total_weight = total_weight + g.weight;
            total_value = total_value +
                ((value_notendency != null ? value_notendency : value0) *
                    g.weight);
          } else {
            total_weight = total_weight + g.weight;
            total_value = total_value +
                (DataUtil_Grade().getGradeValueOf(g.valuekey).value * g.weight);
          }
        }
      });
    } else {
      for (GradeTypeItem mTypeItem in gradeProfile.types.values) {
        double eachtype_total_value = 0.0;
        double eachtype_total_weight = 0.0;
        List<Grade> eachtype_grades = grades.where((Grade g) {
          return mTypeItem.isValidGrade(g);
        }).toList();
        if (eachtype_grades.length != null) {
          eachtype_grades.forEach((Grade g) {
            if (settingsData == null) {
              eachtype_total_weight = eachtype_total_weight + g.weight;
              eachtype_total_value = eachtype_total_value +
                  (DataUtil_Grade().getGradeValueOf(g.valuekey).value *
                      g.weight);
            } else {
              if (settingsData.weight_tendencies == false) {
                double value0 =
                    DataUtil_Grade().getGradeValueOf(g.valuekey).value;
                double value_notendency = DataUtil_Grade()
                    .getGradeValueOf(g.valuekey)
                    .value_notendency;
                eachtype_total_weight = eachtype_total_weight + g.weight;
                eachtype_total_value = eachtype_total_value +
                    ((value_notendency != null ? value_notendency : value0) *
                        g.weight);
              } else {
                eachtype_total_weight = eachtype_total_weight + g.weight;
                eachtype_total_value = eachtype_total_value +
                    (DataUtil_Grade().getGradeValueOf(g.valuekey).value *
                        g.weight);
              }
            }
          });
          if (mTypeItem.testsasoneexam == true) {
            Iterable<Grade> grades_test =
                grades.where((it) => it.type == GradeType.TEST);
            double typetest_total_value = 0.0;
            double typetest_total_weight = 0.0;
            grades_test.forEach((Grade g) {
              if (settingsData == null) {
                typetest_total_weight = typetest_total_weight + g.weight;
                typetest_total_value = typetest_total_value +
                    (DataUtil_Grade().getGradeValueOf(g.valuekey).value *
                        g.weight);
              } else {
                if (settingsData.weight_tendencies == false) {
                  double value0 =
                      DataUtil_Grade().getGradeValueOf(g.valuekey).value;
                  double value_notendency = DataUtil_Grade()
                      .getGradeValueOf(g.valuekey)
                      .value_notendency;
                  typetest_total_weight = typetest_total_weight + g.weight;
                  typetest_total_value = typetest_total_value +
                      ((value_notendency != null ? value_notendency : value0) *
                          g.weight);
                } else {
                  typetest_total_weight = typetest_total_weight + g.weight;
                  typetest_total_value = typetest_total_value +
                      (DataUtil_Grade().getGradeValueOf(g.valuekey).value *
                          g.weight);
                }
              }
            });

            if (typetest_total_weight != 0) {
              Decimal average_oftypetest =
                  Decimal.parse(typetest_total_value.toString()) /
                      Decimal.parse(typetest_total_weight.toString());
              eachtype_total_weight = eachtype_total_weight + 1.0;
              eachtype_total_value =
                  eachtype_total_value + average_oftypetest.toDouble();
            }
          }
          if (eachtype_total_weight != 0.0) {
            Decimal type_average =
                Decimal.parse(eachtype_total_value.toString()) /
                    Decimal.parse(eachtype_total_weight.toString());
            averageperType[mTypeItem] = type_average.toDouble();

            total_value =
                total_value + (averageperType[mTypeItem] * mTypeItem.weight);
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

class AverageReport {
  double totalaverage;
  AverageReport(PlannerSettingsData settingsData, {List<ReportValue> values}) {
    double total_value = 0.0;
    double total_weight = 0.0;

    if (values == null) {
      return;
    }

    for (ReportValue item in values) {
      GradeValue g = DataUtil_Grade().getGradeValueOf(item.grade_key);

      if (settingsData.weight_tendencies == false) {
        double value0 = g.value;
        double value_notendency = g.value_notendency;
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
