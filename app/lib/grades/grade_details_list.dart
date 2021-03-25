//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradeDetail.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

import 'grade_all_view.dart';
import 'grade_courses_view.dart';
import 'grade_info_view.dart';
import 'pages/edit_grade_page.dart';

class GradeDetailList extends StatefulWidget {
  final PlannerDatabase database;
  GradeDetailList(this.database);

  @override
  State<StatefulWidget> createState() => GradeDetailListState(database);
}

class GradeDetailListState extends State<GradeDetailList> {
  final PlannerDatabase database;
  GradeDetailListState(this.database) {
    list = (database.grades.data?.toList() ?? [])
      ..sort((g1, g2) {
        return g1.date!.compareTo(g2.date!);
      });
    list_course = (database.courseinfo.data ?? {}).values.toList()
      ..sort((c1, c2) {
        return c1.getName().compareTo(c2.getName());
      });
    calculator = AverageCalculator(database.getSettings(),
        grades: list ?? [], courses: []);
  }

  late AverageCalculator calculator;
  List<Grade> originallist = [];
  List<Grade> list = [];
  late StreamSubscription<List<Grade>?> datalistener;
  List<Course> list_course = [];
  late StreamSubscription<List<Course>?> datalistener_course;
  late StreamSubscription<GradeSpan?> listener_gradespan;

  late GradeSpan? gradespan;

  @override
  void initState() {
    super.initState();
    datalistener = database.grades.stream.listen((snapshot) {
      setState(() {
        originallist = snapshot == null ? [] : snapshot
          ..sort((g1, g2) {
            return g2.date!.compareTo(g1.date!);
          });
        list = getFilteredList();
        _newCalculation();
      });
    });
    datalistener_course = database.courseinfo.stream.map((datamap) {
      return (datamap ?? {}).values.toList()
        ..sort((c1, c2) {
          return c1.getName().compareTo(c2.getName());
        });
    }).listen((snapshot) {
      setState(() {
        list_course = snapshot;
        _newCalculation();
      });
    });
    listener_gradespan =
        database.gradespanpackage.streamcurrent().listen((newgradespan) {
      setState(() {
        gradespan = newgradespan;
        list = getFilteredList();
        _newCalculation();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    datalistener.cancel();
    datalistener_course.cancel();
    listener_gradespan.cancel();
  }

  void _newCalculation() {
    calculator = AverageCalculator(database.getSettings(),
        grades: list, courses: list_course);
  }

  List<Grade> getFilteredList() {
    if (gradespan != null) {
      return originallist.where((grade) {
        if (gradespan!.start != null) {
          if (gradespan!.start!.compareTo(grade.date!) > 0) return false;
        }
        if (gradespan!.end != null) {
          if (gradespan!.end!.compareTo(grade.date!) < 0) return false;
        }
        return true;
      }).toList();
    } else {
      return originallist;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Choice(0, getString(context).all),
      Choice(1, getString(context).courses),
      Choice(2, getString(context).info),
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: _AppBar(
            gradeSpan: gradespan,
            averageCalculator: calculator,
            database: database,
            tabs: tabs,
          ),
          body: TabBarView(
            children: [
              GradeAllView(
                database: database,
                list: list,
              ),
              GradeCoursesView(
                database: database,
                courseList: list_course,
                calculator: calculator,
                list: list,
              ),
              Builder(builder: (context) {
                return GradeInfoView(
                  database: database,
                  list: list,
                );
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              pushWidget(context, NewGradeView(database));
            },
            icon: const Icon(Icons.add),
            label: Text(getString(context).newgrade),
          ),
        ));
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final AverageCalculator averageCalculator;
  final GradeSpan? gradeSpan;
  final PlannerDatabase database;
  final List<Choice> tabs;

  const _AppBar({
    Key? key,
    required this.averageCalculator,
    required this.gradeSpan,
    required this.database,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 55.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.date_range),
                        SizedBox(
                          width: 8.0,
                        ),
                        if (gradeSpan?.id == 'custom')
                          Column(
                            children: <Widget>[
                              Text(
                                gradeSpan?.getName(context) ?? '-?-',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                gradeSpan!.getStartText(context) +
                                    ' - ' +
                                    gradeSpan!.getEndText(context),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                            mainAxisSize: MainAxisSize.min,
                          )
                        else
                          Text(
                            gradeSpan?.getName(context) ?? '-?-',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Icon(
                          Icons.expand_more,
                          size: 24.0,
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  onTap: () {
                    showGradeSpanSheet(context, database);
                  },
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                Text(
                  'Ø' +
                      (averageCalculator.totalaverage != null
                          ? database
                              .getSettings()
                              .getCurrentAverageDisplay(context: context)
                              .input(averageCalculator.totalaverage)
                          : '/'),
                  style: TextStyle(
                      color: getTextColor(getBackgroundColor(context)),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        ),
        Container(
          height: 45.0,
          child: TabBar(
            tabs: tabs.map((choice) {
              return Tab(
                text: choice.name,
              );
            }).toList(),
            indicatorWeight: 3.0,
            labelColor: getClearTextColor(context),
            unselectedLabelColor: getDividerColor(context),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 100.0);
}
