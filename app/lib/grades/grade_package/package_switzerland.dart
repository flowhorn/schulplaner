import 'package:flutter/material.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';

class GradePackageSwitzerland extends GradePackage {
  static const List<GradeValue> values = [
    GradeValue(
        id: '6-6', value: 6.0, gradepackage: 6, name: '6', name2: 'Sehr gut'),
    GradeValue(id: '6-5', value: 5.0, gradepackage: 6, name: '5', name2: 'Gut'),
    GradeValue(
        id: '6-4', value: 4.0, gradepackage: 6, name: '4', name2: 'Genügend'),
    GradeValue(
        id: '6-3', value: 3.0, gradepackage: 6, name: '3', name2: 'Ungenügend'),
    GradeValue(
        id: '6-2', value: 2.0, gradepackage: 6, name: '2', name2: 'Schwach'),
    GradeValue(
        id: '6-1', value: 1.0, gradepackage: 6, name: '1', name2: 'Schlecht'),
  ];

  GradePackageSwitzerland(BuildContext context)
      : super(
            id: 6,
            name: context != null ? 'Schweiz (6-1)' : '',
            supportSecondName: true,
            inputSupport: false,
            gradevalues: values,
            averagedisplays: [
              AverageDisplay((double value) {
                return value.toStringAsFixed(2);
              }, name: context != null ? 'Noten (6-1)' : ''),
            ],
            getGradeValue: (gradevaluekey) {
              return values.where((GradeValue v) {
                return double.parse(v.id.split('-')[1]) ==
                    double.parse(gradevaluekey.split('-')[1]);
              }).first;
            });
}
