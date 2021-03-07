//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/NewSchoolReportView.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:share/share.dart';

class ReportValue {
  String grade_key;
  double weight;

  ReportValue({this.grade_key, this.weight});

  ReportValue.fromData(Map<String, dynamic> data) {
    grade_key = data['grade_key'];
    var internalweight = data['weight'];
    weight = double.parse(internalweight.toString());
  }

  bool validate() {
    if (grade_key == null || grade_key == '') return false;
    if (weight == null) return false;
    return true;
  }

  Map<String, Object> toJson() {
    return {
      'grade_key': grade_key,
      'weight': weight,
    };
  }
}

class SchoolReport {
  String id;
  String name;
  Map<String, ReportValue> values;
  SchoolReport({this.id, this.name, this.values});

  SchoolReport.fromData(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];

    //DATAMAPS
    Map<String, dynamic> premap_data =
        (data['values'] ?? data['data'])?.cast<String, dynamic>() ?? {};
    premap_data.removeWhere((key, value) => value == null);
    values = premap_data.map<String, ReportValue>((String key, value) =>
        MapEntry(key, ReportValue.fromData(value?.cast<String, dynamic>())));
  }

  SchoolReport copyWith({String id, String name, Map<String, dynamic> values}) {
    return SchoolReport(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  bool validate() {
    if (id == null || id == '') return false;
    if (name == null || name == '') return false;
    return true;
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'values': values?.map((key, value) => MapEntry(key, value?.toJson())),
    };
  }

  ReportValue getValue(String courseid) {
    if (values == null) return null;
    if (values[courseid] == null) return null;
    return values[courseid];
  }
}

class ReportView extends StatefulWidget {
  final PlannerDatabase database;
  final String reportid;
  ReportView({this.database, this.reportid});

  @override
  State<StatefulWidget> createState() => ReportViewState(database, reportid);
}

class ReportViewState extends State<ReportView> {
  final PlannerDatabase database;
  String reportid;
  ReportViewState(this.database, this.reportid);

  List<Grade> list = [];
  StreamSubscription<SchoolReport> datalistener;
  SchoolReport myreport;

  @override
  void initState() {
    datalistener =
        database.schoolreports.getItemStream(reportid).listen((newreport) {
      setState(() {
        myreport = newreport;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    datalistener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Course> courses = database.getCourseList();

    AverageReport averageReport =
        AverageReport(database.getSettings(), values: getValue());

    return Scaffold(
      appBar: AppBar(
        title: Text(getString(context).schoolreport),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child: Container(
            height: 50.0,
            child: ListTile(
              title: Text(
                myreport?.name ?? '',
                style: TextStyle(color: getTextColor(getPrimaryColor(context))),
              ),
              leading: Icon(
                Icons.assignment,
                color: getTextColor(getPrimaryColor(context)),
              ),
              trailing: Text(
                'Ø' +
                    (averageReport.totalaverage != null
                        ? database
                            .getSettings()
                            .getCurrentAverageDisplay(context: context)
                            .input(averageReport.totalaverage)
                        : '/'),
                style: TextStyle(
                    color: getTextColor(getPrimaryColor(context)),
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              String firstpart = (myreport?.name ?? '-') +
                  ': \n ' +
                  getString(context).average +
                  ': ' +
                  database
                      .getSettings()
                      .getCurrentAverageDisplay(context: context)
                      .input(averageReport.totalaverage)
                      .toString() +
                  '\n';
              for (Course c in courses) {
                firstpart = firstpart +
                    c.name +
                    ': ' +
                    (myreport?.getValue(c.id)?.grade_key != null
                        ? (DataUtil_Grade()
                            .getGradeValueOf(myreport.getValue(c.id).grade_key)
                            .name)
                        : '/') +
                    '\n';
              }
              Share.share(firstpart);
            },
            tooltip: getString(context).share,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          Course course = courses[index];
          return ListTile(
            leading: ColoredCircleText(
              text: toShortNameLength(context, course.getShortname_full()),
              color: course.getDesign().primary,
            ),
            title: Text(course.getName()),
            onTap: () {
              pushWidget(
                  context,
                  NewReportValueView(
                    database,
                    report: myreport,
                    courseid: course.id,
                  ));
            },
            trailing: Text(
              myreport?.getValue(course.id)?.grade_key != null
                  ? (DataUtil_Grade()
                      .getGradeValueOf(myreport.getValue(course.id).grade_key)
                      .name)
                  : '/',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          );
        },
      ),
    );
  }

  List<ReportValue> getValue() {
    if (myreport?.values == null) return null;
    return myreport.values.values.toList();
  }
}

class SchoolReportList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  SchoolReportList({@required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<SchoolReport>>(
        stream: plannerDatabase.schoolreports.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SchoolReport> list = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                SchoolReport item = list[index];
                return ListTile(
                  leading: ColoredCircleIcon(
                    icon: Icon(Icons.assignment),
                  ),
                  title: Text(item.name),
                  onTap: () {
                    pushWidget(
                        context,
                        ReportView(
                          database: plannerDatabase,
                          reportid: item.id,
                        ));
                  },
                  trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        showSchoolReportMoreSheet(context,
                            reportid: item.id,
                            plannerdatabase: plannerDatabase);
                      }),
                );
              },
              itemCount: list.length,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pushWidget(context, NewSchoolReportView(plannerDatabase));
        },
        icon: Icon(Icons.add),
        label: Text(getString(context).newschoolreport),
      ),
    );
  }
}

void showSchoolReportMoreSheet(BuildContext context,
    {@required String reportid, @required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolReport>(
            stream: plannerdatabase.schoolreports.getItemStream(reportid),
            builder: (context, snapshot) {
              SchoolReport item = snapshot.data;
              if (item == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, item.name ?? '-'),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(getString(context).edit),
                    onTap: () {
                      pushWidget(
                          context,
                          NewSchoolReportView(
                            plannerdatabase,
                            reportid: item.id,
                            editmode: true,
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text(getString(context).delete),
                    onTap: () {
                      showConfirmDialog(
                              context: context,
                              title: getString(context).delete,
                              action: getString(context).delete,
                              richtext: null)
                          .then((value) {
                        if (value == true) {
                          popNavigatorBy(context, text: 'schoolreportid');
                          plannerdatabase.dataManager.DeleteSchoolReport(item);
                        }
                      });
                    },
                  ),
                  FormSpace(16.0),
                ],
              );
            });
      },
      routname: 'schoolreportid');
}
