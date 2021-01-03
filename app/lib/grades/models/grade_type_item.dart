import 'package:flutter/material.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner8/models/helper_functions.dart';
import 'package:schulplaner8/utils/models/coder.dart';

import 'grade_type.dart';

class GradeTypeItem {
  final String id, name;
  final double weight;
  final Map<GradeType, bool> gradetypes;
  final bool testsasoneexam;

  GradeTypeItem._({
    @required this.id,
    @required this.name,
    @required this.weight,
    @required this.gradetypes,
    @required this.testsasoneexam,
  });

  factory GradeTypeItem.Create(String id) {
    return GradeTypeItem._(
        id: id, name: '', weight: 1.0, testsasoneexam: false, gradetypes: {});
  }

  factory GradeTypeItem.FromData(dynamic data) {
    return GradeTypeItem._(
      id: data['id'],
      name: data['name'],
      weight: parseDoubleFrom(data['weight']),
      testsasoneexam: data['testsasoneexam'] ?? false,
      gradetypes: decodeMap(data['gradetypes'], (key, value) => value)
          .map<GradeType, bool>((key, value) =>
              MapEntry(GradeType.values[int.parse(key)], value)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'gradetypes': gradetypes.map((key, value) {
        return MapEntry(key.index.toString(), value);
      }),
      'testsasoneexam': testsasoneexam,
    };
  }

  List<GradeType> getEnabledCalculationGradeTypes() {
    return gradetypes.entries
        .where((entry) {
          if (entry.key == GradeType.TEST && testsasoneexam == true) {
            return false;
          }
          return entry.value == true;
        })
        .map((entry) => entry.key)
        .toList();
  }

  List<GradeType> getEnabledListedGradeTypes() {
    return gradetypes.entries
        .where((entry) {
          if (entry.key == GradeType.TEST && testsasoneexam == true) {
            return true;
          }
          return entry.value == true;
        })
        .map((entry) => entry.key)
        .toList();
  }

  bool isValidGrade(Grade grade) {
    if (grade.type == GradeType.TEST && testsasoneexam == true) return false;
    if (gradetypes[grade.type] == true) {
      return true;
    } else {
      return false;
    }
  }

  String getGradeTypesListed(BuildContext context) {
    String text = getEnabledListedGradeTypes()
        ?.map((data) => getGradeTypes(context)[data.index].name ?? '-')
        ?.join(', ');
    if (text == null || text == '') {
      return '-';
    } else {
      return text;
    }
  }

  GradeTypeItem copyWith({
    String id,
    String name,
    double weight,
    Map<GradeType, bool> gradetypes,
    bool testsasoneexam,
  }) {
    return GradeTypeItem._(
        id: id ?? this.id,
        name: name ?? this.name,
        weight: weight ?? this.weight,
        testsasoneexam: testsasoneexam ?? this.testsasoneexam,
        gradetypes: gradetypes ?? Map.of(this.gradetypes));
  }
}
