import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/groups/src/models/course.dart';

import 'models/choice.dart';
import 'models/grade.dart';
import 'models/grade_span.dart';

void showGradeSpanSheet(BuildContext context, PlannerDatabase database) {
  showSheetBuilder(
      context: context,
      child: (context) {
        return StreamBuilder<List<GradeSpan>>(
            stream: database.gradespanpackage.streamlist_full,
            builder: (context, snapshot) {
              List<GradeSpan> gradespanlist = snapshot.data ?? [];
              return getFlexList(gradespanlist.map((gradespan) {
                return ListTile(
                  title: Text(gradespan.getName(context)),
                  trailing: gradespan.activated
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : null,
                  onTap: () {
                    if (gradespan.id == 'custom') {
                      selectDateRange(context).then((daterange) {
                        if (daterange != null) {
                          database.gradespanpackage.setGradeSpan(GradeSpan(
                              id: 'custom',
                              start: daterange.start,
                              end: daterange.end,
                              name: getString(context).custom,
                              activated: true));
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      database.gradespanpackage.setGradeSpan(gradespan);
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList());
            });
      },
      title: getString(context).timespan);
}

class DateRange {
  final String? start, end;
  const DateRange({this.start, this.end});

  DateRange copyWith({
    String? start,
    String? end,
  }) {
    return DateRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}

Future<DateRange?> selectDateRange(BuildContext context) {
  ValueNotifier<DateRange> notifier = ValueNotifier(DateRange());
  return showSheetBuilder(
          context: context,
          child: (context) {
            return ValueListenableBuilder<DateRange>(
                valueListenable: notifier,
                builder: (context, value, _) {
                  DateRange range = value;
                  return getFlexList([
                    ListTile(
                      title: Text(getString(context).start),
                      subtitle: Text(range.start != null
                          ? getDateText(range.start!)
                          : getString(context).open),
                      onTap: () {
                        selectDateString(context, range.start)
                            .then((newdatestring) {
                          if (newdatestring != null) {
                            notifier.value =
                                range.copyWith(start: newdatestring);
                          }
                        });
                      },
                    ),
                    ListTile(
                      title: Text(getString(context).end),
                      subtitle: Text(range.end != null
                          ? getDateText(range.end!)
                          : getString(context).open),
                      onTap: () {
                        selectDateString(context, range.end)
                            .then((newdatestring) {
                          if (newdatestring != null) {
                            notifier.value = range.copyWith(end: newdatestring);
                          }
                        });
                      },
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context, range);
                      },
                      child: Text(getString(context).set),
                    ),
                  ]);
                });
          },
          title: getString(context).selecttimespan)
      .then<DateRange?>((value) {
    if (value is DateRange) {
      return value;
    } else {
      return null;
    }
  });
}

void showGradeInfoSheet(PlannerDatabase database,
    {required BuildContext context, required String gradeid}) {
  showDetailSheetBuilder(
    context: context,
    body: (BuildContext context) {
      return StreamBuilder<Grade?>(
        stream: database.grades.getItemStream(gradeid),
        builder: (BuildContext context, snapshot) {
          Grade? item = snapshot.data;
          if (item == null) return loadedView();
          Course? courseInfo = database.getCourseInfo(item.courseid!);

          return Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getSheetText(context, item.title ?? '-'),
              getExpandList([
                ListTile(
                  leading: Icon(
                    Icons.school,
                    color: courseInfo == null
                        ? null
                        : courseInfo.getDesign()?.primary,
                  ),
                  title:
                      Text(courseInfo == null ? '???' : courseInfo.getName()),
                  onTap: () {},
                ),
                ListTile(
                    leading: Icon(Icons.grade),
                    title: Text(DataUtil_Grade()
                        .getGradeValueOf(item.valuekey!)
                        .getLongName())),
                ListTile(
                    leading: Icon(Icons.today),
                    title: Text(getDateText(item.date!))),
                ListTile(
                    leading: Icon(Icons.line_weight),
                    title: Text(item.weight.toString())),
                ListTile(
                    leading:
                        Icon(getGradeTypes(context)[item.type.index].iconData),
                    title: Text(getGradeTypes(context)[item.type.index].name)),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonBar(
                  children: <Widget>[
                    //RButton(text: "Anrufen", onTap: () {}),
                    RButton(
                        text: getString(context).more,
                        onTap: () {
                          showSheetBuilder(
                              context: context,
                              child: (context) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text(getString(context).edit),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pushWidget(
                                          context,
                                          NewGradeView(
                                            database,
                                            editmode: true,
                                            gradeid: item.id,
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete_outline),
                                      title: Text(getString(context).delete),
                                      onTap: () {
                                        showConfirmDialog(
                                                context: context,
                                                title:
                                                    getString(context).delete,
                                                action:
                                                    getString(context).delete,
                                                richtext: null)
                                            .then((result) {
                                          if (result == true) {
                                            database.dataManager
                                                .DeleteGrade(item);
                                            popNavigatorBy(context,
                                                text: 'gradeid');
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                              title: getString(context).more,
                              routname: 'gradeidview');
                        },
                        iconData: Icons.more_horiz),
                  ],
                ),
              ),
              FormSpace(16.0),
            ],
          ));
        },
      );
    },
    routname: 'gradeidview',
  );
}

Widget getTitleCard(
    {IconData? iconData,
    required String title,
    required List<Widget> content,
    Widget? bottom}) {
  List<Widget> widgetlist = [
    Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 12.0, bottom: 12.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 18.0,
              color: Colors.grey,
            ),
            Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        )),
  ];
  widgetlist..addAll(content);
  if (bottom != null) widgetlist.add(bottom);
  return Padding(
    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
    child: FormEasyField(
        child: Column(
      children: widgetlist,
    )),
  );
}
