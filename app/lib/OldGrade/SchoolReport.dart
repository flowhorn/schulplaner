import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/OldGrade/school_report_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/NewSchoolReportView.dart';

import 'models/school_report.dart';

class SchoolReportList extends StatelessWidget {
  final PlannerDatabase plannerDatabase;
  SchoolReportList({required this.plannerDatabase});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<SchoolReport>>(
        stream: plannerDatabase.schoolreports.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SchoolReport> list = snapshot.data ?? [];
            return ListView.builder(
              itemBuilder: (context, index) {
                SchoolReport item = list[index];
                return ListTile(
                  leading: ColoredCircleIcon(
                    icon: Icon(Icons.assignment),
                  ),
                  title: Text(item.name),
                  onTap: () {
                    openSchoolReportPage(context: context, reportId: item.id);
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
    {required String reportid, required PlannerDatabase plannerdatabase}) {
  showDetailSheetBuilder(
      context: context,
      body: (context) {
        return StreamBuilder<SchoolReport?>(
            stream: plannerdatabase.schoolreports.getItemStream(reportid),
            builder: (context, snapshot) {
              SchoolReport? item = snapshot.data;
              if (item == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, item.name),
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
