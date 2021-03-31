import 'package:flutter/material.dart';

import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/OldGrade/models/grade_value.dart';

class GradePackage9_1 extends GradePackage {
  static const List<GradeValue> values = [
    GradeValue(id: '7-9', value: 9.0, gradepackage: 7, name: '9'),
    GradeValue(id: '7-8', value: 8.0, gradepackage: 7, name: '8'),
    GradeValue(id: '7-7', value: 7.0, gradepackage: 7, name: '7'),
    GradeValue(id: '7-6', value: 6.0, gradepackage: 7, name: '6'),
    GradeValue(id: '7-5', value: 5.0, gradepackage: 7, name: '5'),
    GradeValue(id: '7-4', value: 4.0, gradepackage: 7, name: '4'),
    GradeValue(id: '7-3', value: 3.0, gradepackage: 7, name: '3'),
    GradeValue(id: '7-2', value: 2.0, gradepackage: 7, name: '2'),
    GradeValue(id: '7-1', value: 1.0, gradepackage: 7, name: '1'),
  ];

  GradePackage9_1(BuildContext? context)
      : super(
            id: 7,
            name: context != null ? '9-1' : '',
            supportSecondName: false,
            inputSupport: false,
            gradevalues: values,
            getGradeValue: (gradevaluekey) {
              return values.where((GradeValue v) {
                return double.parse(v.id.split('-')[1]) ==
                    double.parse(gradevaluekey.split('-')[1]);
              }).first;
            });
}
