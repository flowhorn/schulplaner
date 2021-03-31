import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/grades/models/grade_type.dart';

import 'grade_value.dart';

class Grade {
  Grade({
    this.id,
    this.courseid,
    this.title,
    this.date,
    this.valuekey,
    this.weight = 1.0,
    required this.type,
  });

  String? id, courseid, title, date, valuekey;
  late double weight;
  late GradeType type;

  Grade copy({
    String? id,
    String? courseid,
    String? title,
    String? date,
    String? valuekey,
    String? sectionid,
    double? weight,
    GradeType? type,
  }) {
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

  String getKey() => courseid! + '--' + id!;

  Grade.fromData(Map<String, dynamic> data) {
    id = data['gradeid'] ?? data['id'];
    courseid = data['courseid'] ?? data['coursid'];
    title = data['title'] ?? data['name'];
    date = data['date'];
    valuekey = data['valueid'];

    weight = double.parse(data['weight'].toString());
    type = GradeType.values[data['type'] - 1];
  }

  Map<String, dynamic> toJson() {
    return {
      'gradeid': id,
      'courseid': courseid,
      'title': title,
      'date': date,
      'valueid': valuekey,
      'weight': weight,
      'type': type.index + 1,
    };
  }

  bool isValid() {
    return id != null;
  }

  bool validate() {
    if (id == null || id == '') return false;
    if (courseid == null || courseid == '') return false;
    if (date == null || date == '') return false;
    if (title == null || title == '') return false;
    if (weight == null) return false;
    if (valuekey == null || valuekey == '') return false;
    return true;
  }
}

class DataUtil_Grade {
  String getKey(Grade item) => item.getKey();

  static String getKeyBy(String courseid, String gradeid) {
    return courseid + '--' + gradeid;
  }

  int sort(Grade item1, Grade item2) {
    return item1.date!.compareTo(item2.date!);
  }

  GradeValue getGradeValueOf(String gradevaluekey) {
    return getGradePackageOf(gradevaluekey).getGradeValue!(gradevaluekey);
  }

  GradePackage getGradePackageOf(String gradevaluekey) {
    return getGradePackage(int.parse(gradevaluekey.split('-')[0]));
  }
}
