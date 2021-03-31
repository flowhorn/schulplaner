import 'package:schulplaner8/grades/models/grade_type.dart';

class AverageSettings {
  late bool automatic;
  late Map<GradeType, double> weightperType;
  AverageSettings({this.automatic = true, required this.weightperType}) {
    if (weightperType == null) {
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
  AverageSettings.fromJson(dynamic json) {
    automatic = json != null ? json['automatic'] : true;
    final List<dynamic>? weightlist =
        json != null ? json['weightpertype'] : null;
    if (weightlist != null) {
      weightperType = weightlist.asMap().map((int key, dynamic value) {
        return MapEntry<GradeType, double>(
            GradeType.values[int.parse(value.split('-')[0])],
            double.parse(value.split('-')[1]));
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
      'automatic': automatic,
      'weightpertype':
          weightperType.entries.map((MapEntry<GradeType, double> entry) {
        return entry.key.index.toString() + '-' + entry.value.toString();
      }).toList(),
    };
  }
}
