import 'package:bloc/bloc_provider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Overview.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/grades/pages/edit_grade_page.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyAbsentTime.dart';
import 'package:schulplaner8/Views/SchoolPlanner/events/edit_event_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/lessoninfo/edit_lesson_info_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/tasks/edit_task_page.dart';

class QuickCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database =
        BlocProvider.of<PlannerDatabaseBloc>(context).plannerDatabase;
    return Column(
      children: <Widget>[
        FormSpace(8.0),
        FormSection(
          title: getString(context).create_quickly,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  Hero(
                      tag: 'fab',
                      child: QuickActionView(
                          iconData: Icons.book,
                          text: getString(context).task,
                          color: Colors.greenAccent,
                          onTap: () {
                            pushWidget(
                                context,
                                NewSchoolTaskView(
                                  database: database,
                                ));
                          })),
                  QuickActionView(
                      iconData: Icons.event_note,
                      text: getString(context).event,
                      color: Colors.blueGrey,
                      onTap: () {
                        pushWidget(
                            context,
                            NewSchoolEventView.Create(
                              database: database,
                            ));
                      }),
                  QuickActionView(
                      iconData: CommunityMaterialIcons.trophy_outline,
                      text: getString(context).grade,
                      color: Colors.indigoAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewGradeView(
                              database,
                            ));
                      }),
                  QuickActionView(
                      iconData: Icons.info_outline,
                      text: getString(context).info,
                      color: Colors.purpleAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewLessonInfoView(
                              database,
                            ));
                      }),
                  QuickActionView(
                      iconData: Icons.not_interested,
                      text: getString(context).absenttime,
                      color: Colors.redAccent,
                      onTap: () {
                        pushWidget(
                            context,
                            NewAbsentTimeView.Create(
                              database: database,
                            ));
                      }),
                ],
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }
}
