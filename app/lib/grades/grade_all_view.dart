import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradeDetail.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class GradeAllView extends StatelessWidget {
  final PlannerDatabase database;
  final List<Grade> list;

  const GradeAllView({Key key, this.database, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpListView(
      items: list,
      builder: (context, grade) {
        final courseInfo = database.getCourseInfo(grade.courseid);
        if (grade == null) {
          return ListTile(
            title: Text(getString(context).error),
          );
        }
        return Column(
          children: <Widget>[
            Divider(
              height: 1.0,
            ),
            ListTile(
              onTap: () {
                showGradeInfoSheet(database,
                    context: context, gradeid: grade.id);
              },
              leading: ColoredCircleText(
                color: courseInfo == null
                    ? getPrimaryColor(context)
                    : courseInfo.getDesign().primary,
                text: courseInfo == null
                    ? '???'
                    : toShortNameLength(
                        context, courseInfo.getShortname_full()),
              ),
              title: Text(grade.title),
              subtitle: Column(
                children: <Widget>[
                  Text(courseInfo == null
                      ? 'Fach nicht vorhanden'
                      : courseInfo.name),
                  Text(getDateText(grade.date)),
                ],
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              isThreeLine: true,
              trailing: Text(
                DataUtil_Grade().getGradeValueOf(grade.valuekey).name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            )
          ],
        );
      },
      emptyViewBuilder: (context) =>
          getEmptyView(title: getString(context).nogrades),
    );
  }
}
