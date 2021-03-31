import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/grades/grade_package/package_9_1.dart';
import 'package:schulplaner8/grades/grade_package/package_switzerland.dart';

import 'models/average_display.dart';
import 'models/grade_value.dart';

class GradePackage {
  int id;
  String name;
  List<GradeValue> gradevalues;
  bool supportSecondName;
  bool inputSupport;
  List<AverageDisplay>? averagedisplays;
  GetGradeValue? getGradeValue;
  GradePackage(
      {required this.id,
      required this.name,
      required this.gradevalues,
      this.supportSecondName = false,
      this.inputSupport = false,
      this.getGradeValue,
      this.averagedisplays}) {
    if (getGradeValue == null) {
      getGradeValue = (String gradevaluekey) {
        return gradevalues.where((GradeValue v) {
          return double.parse(v.id.split('-')[1]) ==
              double.parse(gradevaluekey.split('-')[1]);
        }).first;
      };
    }
    if (averagedisplays == null) {
      averagedisplays = [
        AverageDisplay((double value) {
          return value.toStringAsFixed(2);
        })
      ];
    }
  }

  @override
  String toString() {
    return name;
  }
}

List<GradePackage> getGradePackages(BuildContext context) {
  return [
    getGradePackage(1, context: context),
    getGradePackage(2, context: context),
    getGradePackage(3, context: context),
    getGradePackage(4, context: context),
    getGradePackage(5, context: context),
    getGradePackage(6, context: context),
    getGradePackage(7, context: context),
  ];
}

GradePackage getGradePackage(int id, {BuildContext? context}) {
  switch (id) {
    case 1:
      {
        return GradePackage(
            id: 1,
            name: context != null ? 'Standard (1-6)' : '',
            supportSecondName: true,
            inputSupport: false,
            gradevalues: [
              GradeValue(
                  id: '1-15',
                  value: 15.0,
                  gradepackage: 1,
                  name: '1+',
                  name2: 'Sehr gut plus',
                  value_notendency: 14.0),
              GradeValue(
                  id: '1-14',
                  value: 14.0,
                  gradepackage: 1,
                  name: '1',
                  name2: 'Sehr gut'),
              GradeValue(
                  id: '1-13',
                  value: 13.0,
                  gradepackage: 1,
                  name: '1-',
                  name2: 'Sehr gut minus',
                  value_notendency: 14.0),
              GradeValue(
                  id: '1-12',
                  value: 12.0,
                  gradepackage: 1,
                  name: '2+',
                  name2: 'Gut plus',
                  value_notendency: 11.0),
              GradeValue(
                  id: '1-11',
                  value: 11.0,
                  gradepackage: 1,
                  name: '2',
                  name2: 'Gut'),
              GradeValue(
                  id: '1-10',
                  value: 10.0,
                  gradepackage: 1,
                  name: '2-',
                  name2: 'Gut minus',
                  value_notendency: 11.0),
              GradeValue(
                  id: '1-9',
                  value: 9.0,
                  gradepackage: 1,
                  name: '3+',
                  name2: 'Befriedigend plus',
                  value_notendency: 8.0),
              GradeValue(
                  id: '1-8',
                  value: 8.0,
                  gradepackage: 1,
                  name: '3',
                  name2: 'Befriedigend'),
              GradeValue(
                  id: '1-7',
                  value: 7.0,
                  gradepackage: 1,
                  name: '3-',
                  name2: 'Befriedigend minus',
                  value_notendency: 8.0),
              GradeValue(
                  id: '1-6',
                  value: 6.0,
                  gradepackage: 1,
                  name: '4+',
                  name2: 'Ausreichend plus',
                  value_notendency: 5.0),
              GradeValue(
                  id: '1-5',
                  value: 5.0,
                  gradepackage: 1,
                  name: '4',
                  name2: 'Ausreichend'),
              GradeValue(
                  id: '1-4',
                  value: 4.0,
                  gradepackage: 1,
                  name: '4-',
                  name2: 'Ausreichend minus',
                  value_notendency: 5.0),
              GradeValue(
                  id: '1-3',
                  value: 3.0,
                  gradepackage: 1,
                  name: '5+',
                  name2: 'Mangelhaft plus',
                  value_notendency: 2.0),
              GradeValue(
                  id: '1-2',
                  value: 2.0,
                  gradepackage: 1,
                  name: '5',
                  name2: 'Mangelhaft'),
              GradeValue(
                  id: '1-1',
                  value: 1.0,
                  gradepackage: 1,
                  name: '5-',
                  name2: 'Mangelhaft minus',
                  value_notendency: 2.0),
              GradeValue(
                  id: '1-0',
                  value: 0.0,
                  gradepackage: 1,
                  name: '6',
                  name2: 'Ungenügend')
            ],
            averagedisplays: [
              AverageDisplay((double value) {
                return ((17 - value) / 3).toStringAsFixed(2);
              }, name: context != null ? 'Noten (1-6)' : ''),
            ]);
      }
    case 2:
      {
        return GradePackage(
            id: 2,
            name: context != null ? 'Punktesystem (15-0)' : '',
            supportSecondName: true,
            inputSupport: false,
            gradevalues: [
              GradeValue(
                  id: '2-15',
                  value: 15.0,
                  gradepackage: 2,
                  name: '15',
                  name2: 'Sehr gut plus'),
              GradeValue(
                  id: '2-14',
                  value: 14.0,
                  gradepackage: 2,
                  name: '14',
                  name2: 'Sehr gut'),
              GradeValue(
                  id: '2-13',
                  value: 13.0,
                  gradepackage: 2,
                  name: '13',
                  name2: 'Sehr gut minus'),
              GradeValue(
                  id: '2-12',
                  value: 12.0,
                  gradepackage: 2,
                  name: '12',
                  name2: 'Gut plus'),
              GradeValue(
                  id: '2-11',
                  value: 11.0,
                  gradepackage: 2,
                  name: '11',
                  name2: 'Gut'),
              GradeValue(
                  id: '2-10',
                  value: 10.0,
                  gradepackage: 2,
                  name: '10',
                  name2: 'Gut minus'),
              GradeValue(
                  id: '2-9',
                  value: 9.0,
                  gradepackage: 2,
                  name: '9',
                  name2: 'Befriedigend plus'),
              GradeValue(
                  id: '2-8',
                  value: 8.0,
                  gradepackage: 2,
                  name: '8',
                  name2: 'Befriedigend'),
              GradeValue(
                  id: '2-7',
                  value: 7.0,
                  gradepackage: 2,
                  name: '7',
                  name2: 'Befriedigend minus'),
              GradeValue(
                  id: '2-6',
                  value: 6.0,
                  gradepackage: 2,
                  name: '6',
                  name2: 'Ausreichend plus'),
              GradeValue(
                  id: '2-5',
                  value: 5.0,
                  gradepackage: 2,
                  name: '5',
                  name2: 'Ausreichend'),
              GradeValue(
                  id: '2-4',
                  value: 4.0,
                  gradepackage: 2,
                  name: '4',
                  name2: 'Ausreichend minus'),
              GradeValue(
                  id: '2-3',
                  value: 3.0,
                  gradepackage: 2,
                  name: '3',
                  name2: 'Mangelhaft plus'),
              GradeValue(
                  id: '2-2',
                  value: 2.0,
                  gradepackage: 2,
                  name: '2',
                  name2: 'Mangelhaft'),
              GradeValue(
                  id: '2-1',
                  value: 1.0,
                  gradepackage: 2,
                  name: '1',
                  name2: 'Mangelhaft minus'),
              GradeValue(
                  id: '2-0',
                  value: 0.0,
                  gradepackage: 2,
                  name: '0',
                  name2: 'Ungenügend')
            ],
            averagedisplays: [
              AverageDisplay((double value) {
                return ((17 - value) / 3).toStringAsFixed(2);
              }, name: context != null ? 'Noten (1-6)' : ''),
              AverageDisplay((double value) {
                return value.toStringAsFixed(2);
              }, name: context != null ? 'Punktesystem' : ''),
            ]);
      }
    case 3:
      {
        return GradePackage(
            id: 3,
            name: context != null ? 'Österreich (1-5)' : '',
            supportSecondName: true,
            inputSupport: false,
            gradevalues: [
              GradeValue(
                  id: '3-01',
                  value: 14.0,
                  gradepackage: 3,
                  name: '1',
                  name2: 'Sehr gut'),
              GradeValue(
                  id: '3-02',
                  value: 11.0,
                  gradepackage: 3,
                  name: '2',
                  name2: 'Gut'),
              GradeValue(
                  id: '3-03',
                  value: 8.0,
                  gradepackage: 3,
                  name: '3',
                  name2: 'Befriedigend'),
              GradeValue(
                  id: '3-04',
                  value: 5.0,
                  gradepackage: 3,
                  name: '4',
                  name2: 'Genügend'),
              GradeValue(
                  id: '3-05',
                  value: 2.0,
                  gradepackage: 3,
                  name: '5',
                  name2: 'Nicht genügend'),
            ],
            averagedisplays: [
              AverageDisplay((double value) {
                return ((17 - value) / 3).toStringAsFixed(2);
              }, name: context != null ? 'Noten (1-5)' : ''),
            ],
            getGradeValue: (gradevaluekey) {
              return getGradePackage(3).gradevalues.where((GradeValue v) {
                return double.parse(v.id.split('-')[1]) ==
                    double.parse(gradevaluekey.split('-')[1]);
              }).first;
            });
      }
    case 4:
      {
        return GradePackage(
            id: 4,
            name: context != null ? 'Dezimalsystem (frei wählbar)' : '',
            supportSecondName: false,
            inputSupport: true,
            gradevalues: [],
            averagedisplays: [
              AverageDisplay((double value) {
                return value.toStringAsFixed(2);
              }, name: context != null ? 'Standard' : ''),
            ],
            getGradeValue: (String valuekey) {
              return GradeValue(
                  id: valuekey,
                  name: valuekey.split('-')[1].toString(),
                  gradepackage: 4,
                  value: double.parse(valuekey.split('-')[1]));
            });
      }
    case 5:
      {
        return GradePackage(
            id: 5,
            name: context != null ? 'Prozentual (0-100)' : '',
            supportSecondName: false,
            inputSupport: false,
            gradevalues: buildIntList(100, start: 0)
                .map((int i) {
                  return GradeValue(
                      id: 5.toString() + '- ' + i.toString(),
                      name: i.toString() + '%',
                      gradepackage: 5,
                      value: i.toDouble());
                })
                .toList()
                .reversed
                .toList(),
            averagedisplays: [
              AverageDisplay((double value) {
                return value.toStringAsFixed(2) + '%';
              }, name: context != null ? 'Standard' : ''),
            ]);
      }
    case 6:
      {
        return GradePackageSwitzerland(context);
      }
    case 7:
      {
        return GradePackage9_1(context);
      }
  }
  return getGradePackage(1, context: context);
}
