//
import 'package:flutter/material.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/leave_course.dart';
import 'package:schulplaner8/groups/src/bloc/edit_course_bloc.dart';
import 'package:schulplaner8/groups/src/pages/edit_course_page.dart';
import 'package:schulplaner8/teachers/teacher_detail_sheet.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/Planner/Letter.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Courses.dart';
import 'package:schulplaner8/Views/SchoolPlanner/MyLetters.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Places.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_member_page.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_personal_config.dart';
import 'package:schulplaner8/Views/SchoolPlanner/course/course_public_code.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class CourseView extends StatelessWidget {
  final String courseid;
  final PlannerDatabase database;

  CourseView({required this.courseid, required this.database});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course?>(
      builder: (context, snapshot) {
        Course? courseInfo = snapshot.data;
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design courseDesign = courseInfo.getDesign()!;
        return Theme(
          data: newAppThemeDesign(context, courseDesign),
          child: Scaffold(
            appBar: AppHeaderAdvanced(
              title: Text(courseInfo.getName()),
            ),
            body: LimitedContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    QuickCreateCourseView(
                      database: database,
                      courseid: courseInfo.id,
                    ),
                    FormHeader2(getString(context).schoolletters),
                    StreamBuilder<Map<String, Letter>>(
                      builder: (context, snapshot) {
                        List<Letter> datalist = snapshot.data!.values
                            .where((letter) {
                          return letter.savedin!.id == courseInfo.id;
                        }).toList()
                          ..sort(
                              (l1, l2) => l1.published.compareTo(l2.published));
                        return Column(
                          children: datalist.map((letter) {
                            return LetterCard(
                              letter: letter,
                              database: database,
                            );
                          }).toList(),
                        );
                      },
                      stream: database.letters.stream.map((datamap) => datamap),
                      initialData: database.letters.data,
                    ),
                    ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: getString(context).create,
                            onTap: () {
                              pushWidget(
                                  context,
                                  NewLetterView.Create(
                                    database: database,
                                    savein: SavedIn(
                                        id: courseInfo.id,
                                        type: SavedInType.COURSE),
                                  ));
                            },
                            iconData: Icons.add),
                      ],
                    ),
                    FormSection(
                      title: getString(context).informations,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Hero(
                                tag: 'courestag:' + courseInfo.id,
                                child: ColoredCircleText(
                                  color: courseInfo.getDesign()!.primary,
                                  text: toShortNameLength(
                                      context, courseInfo.getShortname_full()),
                                )),
                            title: Text(courseInfo.getName()),
                          ),
                          Column(
                            children: courseInfo.teachers.values.map((it) {
                              return ListTile(
                                leading: Icon(Icons.person_outline),
                                title: Text(it?.name ?? '-'),
                                onTap: () {
                                  showTeacherDetail(
                                      context: context,
                                      plannerdatabase: database,
                                      teacherid: it!.teacherid);
                                },
                              );
                            }).toList(),
                          ),
                          Column(
                            children: courseInfo.places.values.map((it) {
                              return ListTile(
                                leading: Icon(Icons.place),
                                title: Text(it?.name ?? '-'),
                                onTap: () {
                                  showPlaceDetail(
                                      context: context,
                                      plannerdatabase: database,
                                      placeid: it!.placeid);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    FormSection(
                        title: getString(context).publiccode,
                        child: CoursePublicCodeView(
                          database: database,
                          courseid: courseid,
                        )),
                    FormSection(
                      title: getString(context).options,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.people_outline),
                            title: Text(getString(context).members),
                            subtitle:
                                Text(courseInfo.membersData.length.toString()),
                            onTap: () {
                              pushWidget(
                                  context,
                                  CourseMemberView(
                                    courseID: courseid,
                                  ));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.person_outline),
                            title: Text(
                              bothlang(context,
                                  en: 'Custom configuration',
                                  de: 'Eigene Einstellungen'),
                            ),
                            onTap: () {
                              pushWidget(
                                  context,
                                  CoursePersonalPage(
                                    database: database,
                                    courseID: courseInfo.id,
                                  ));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(
                              getString(context).informations,
                            ),
                            onTap: () {
                              openEditCoursePage(
                                context: context,
                                editCourseBloc: EditCourseBloc.withEditState(
                                  course: courseInfo,
                                  database: database,
                                  courseGateway: database.courseGateway,
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.local_drink),
                            title: Text(getString(context).connectedclasses),
                            onTap: () {
                              pushWidget(
                                  context,
                                  CourseConnectedClassesView(
                                      courseid: courseInfo.id,
                                      database: database));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.lock_outline),
                            title: Text(getString(context).security),
                            onTap: () {
                              pushWidget(
                                  context,
                                  CourseSecurityView(
                                      courseid: courseid, database: database));
                            },
                          ),
                        ],
                      ),
                    ),
                    FormHeader2(getString(context).further),
                    RButton(
                      text: getString(context).leavecourse,
                      onTap: () {
                        tryToLeaveCourse(context, courseInfo);
                      },
                      enabled: database.connectionsState.directconnections
                          .containsKey(courseInfo.id),
                    ),
                    FormSpace(64.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      stream: database.courseinfo.getItemStream(courseid),
      initialData: database.courseinfo.data[courseid],
    );
  }
}
