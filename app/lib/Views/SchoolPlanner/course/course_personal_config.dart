import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/ObjectsPlanner.dart';
import 'package:schulplaner8/grades/models/grade_profile.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Pickers.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class CoursePersonalPage extends StatelessWidget {
  final String courseID;
  final PlannerDatabase database;
  CoursePersonalPage({required this.courseID, required this.database});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course>(
      builder: (context, snapshot) {
        Course courseInfo = snapshot.data;
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Design courseDesign = courseInfo.getDesign();
        return Theme(
            data: newAppThemeDesign(context, courseDesign),
            child: Scaffold(
              appBar: AppHeaderAdvanced(
                title: Text(courseInfo.getName()),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.developer_board),
                    onPressed: () {
                      final infoDialog = InfoDialog(
                        title: 'CourseId:',
                        message: courseID ?? '???',
                      );
                      // ignore: unawaited_futures
                      infoDialog.show(context);
                      print(courseID);
                    },
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  FormHeader(
                    getString(context).personal,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: courseInfo.personaldesign?.primary ??
                          Colors.grey[500],
                    ),
                    title: Text(
                      getString(context).mydesign,
                    ),
                    subtitle: Text(courseInfo.personaldesign?.name ?? '-'),
                    onTap: () {
                      selectDesign(context, courseInfo.personaldesign?.id)
                          .then((newdesign) {
                        if (newdesign != null) {
                          CoursePersonal newcoursepersonal =
                              database.courseinfo.secondarydata[courseInfo.id];
                          if (newcoursepersonal == null) {
                            newcoursepersonal =
                                CoursePersonal(courseid: courseInfo.id);
                          }
                          newcoursepersonal.design = newdesign;
                          database.dataManager
                              .ModifyCoursePersonal(newcoursepersonal);
                        }
                      });
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          CoursePersonal newcoursepersonal =
                              database.courseinfo.secondarydata[courseInfo.id];
                          if (newcoursepersonal == null) {
                            newcoursepersonal =
                                CoursePersonal(courseid: courseInfo.id);
                          }
                          newcoursepersonal.design = null;
                          database.dataManager
                              .ModifyCoursePersonal(newcoursepersonal);
                        }),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.data_usage,
                    ),
                    title: Text(
                      getString(context).mygradeprofile,
                    ),
                    subtitle: Text(database
                        .getSettings()
                        .getGradeProfile(courseInfo.personalgradeprofile)
                        .name),
                    onTap: () {
                      selectItem<GradeProfile>(
                          context: context,
                          items: database
                              .getSettings()
                              .gradeprofiles
                              .values
                              .toList(),
                          builder: (context, item) {
                            return ListTile(
                              title: Text(item.name),
                              trailing: item.profileid ==
                                      courseInfo.personalgradeprofile
                                  ? Icon(Icons.done, color: Colors.green)
                                  : null,
                              onTap: () {
                                CoursePersonal newcoursepersonal = database
                                    .courseinfo.secondarydata[courseInfo.id];
                                if (newcoursepersonal == null) {
                                  newcoursepersonal =
                                      CoursePersonal(courseid: courseInfo.id);
                                }
                                newcoursepersonal.gradeprofileid =
                                    item.profileid;
                                database.dataManager
                                    .ModifyCoursePersonal(newcoursepersonal);
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          CoursePersonal newcoursepersonal =
                              database.courseinfo.secondarydata[courseInfo.id];
                          if (newcoursepersonal == null) {
                            newcoursepersonal =
                                CoursePersonal(courseid: courseInfo.id);
                          }
                          newcoursepersonal.gradeprofileid = null;
                          database.dataManager
                              .ModifyCoursePersonal(newcoursepersonal);
                        }),
                  ),
                  ListTile(
                    title: Text(
                      getString(context).myshortname,
                    ),
                    subtitle: Text(courseInfo.personalshortname ?? '-'),
                    onTap: () {
                      getTextFromInput(
                              context: context,
                              previousText: courseInfo.personalshortname,
                              title: getString(context).shortname,
                              maxlength: 5)
                          .then((newtext) {
                        if (newtext != null && newtext != '') {
                          CoursePersonal newcoursepersonal =
                              database.courseinfo.secondarydata[courseInfo.id];
                          if (newcoursepersonal == null) {
                            newcoursepersonal =
                                CoursePersonal(courseid: courseInfo.id);
                          }
                          newcoursepersonal.shortname = newtext;
                          database.dataManager
                              .ModifyCoursePersonal(newcoursepersonal);
                        }
                      });
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          CoursePersonal newcoursepersonal =
                              database.courseinfo.secondarydata[courseInfo.id];
                          if (newcoursepersonal == null) {
                            newcoursepersonal =
                                CoursePersonal(courseid: courseInfo.id);
                          }
                          newcoursepersonal.shortname = null;
                          database.dataManager
                              .ModifyCoursePersonal(newcoursepersonal);
                        }),
                  ),
                  FormDivider(),
                ],
              ),
            ));
      },
      stream: database.courseinfo.getItemStream(courseID),
    );
  }
}
