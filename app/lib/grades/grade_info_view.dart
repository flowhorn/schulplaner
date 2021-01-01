import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';

import 'grade_development_view.dart';

class GradeInfoView extends StatelessWidget {
  final PlannerDatabase database;
  final List<Grade> list;

  const GradeInfoView({Key key, this.database, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GradePackage gradePackage =
        database.getSettings().getCurrentGradePackage(context: context);
    final List<Grade> grades = list.reversed.toList();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          LimitedBox(
            maxHeight: 400.0,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: GradeDevelopmentView(
                grades: grades,
                gradePackage: gradePackage,
              ),
            ),
          ),
          FormSpace(64.0),
        ],
      ),
    );
  }
}
