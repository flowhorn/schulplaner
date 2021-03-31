import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/public_code_functions.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner_functions/schulplaner_functions.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:share/share.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class CoursePublicCodeView extends StatelessWidget {
  final String courseid;
  final PlannerDatabase database;
  CoursePublicCodeView({required this.courseid, required this.database});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Course?>(
      builder: (context, snapshot) {
        final Course? courseInfo = snapshot.data;
        if (courseInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (courseInfo.publiccode != null && courseInfo.joinLink == null) {
          database.requestCourseLink(courseInfo.id);
        }
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    getString(context).publiccode,
                  ),
                ),
                ListTile(
                  title: SelectableText(
                    courseInfo.publiccode != null
                        ? ('#' + courseInfo.publiccode!)
                        : ('#??????'),
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text(
                    courseInfo.joinLink ?? '???',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.lightBlue,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(courseInfo.joinLink!);
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    children: <Widget>[
                      courseInfo.publiccode != null
                          ? nowidget()
                          : RButton(
                              text: getString(context).generate,
                              onTap: () {
                                ValueNotifier<bool?> sheetnotifier =
                                    ValueNotifier(null);
                                showLoadingStateSheet(
                                    context: context,
                                    sheetUpdate: sheetnotifier);
                                requestPermissionCourse(
                                        database: database,
                                        category: PermissionAccessType.edit,
                                        courseid: courseid)
                                    .then((result) {
                                  if (result == true) {
                                    PublicCodeFunctions(
                                            SchulplanerFunctionsBloc.of(
                                                context))
                                        .generatePublicCode(
                                      id: courseInfo.id,
                                      codetype: 0,
                                    )
                                        .then((code) {
                                      sheetnotifier.value = code != null;
                                    });
                                  } else {
                                    sheetnotifier.value = false;
                                  }
                                });
                              },
                              iconData: Icons.refresh),
                      courseInfo.publiccode == null
                          ? nowidget()
                          : RButton(
                              text: getString(context).removecode,
                              onTap: () {
                                ValueNotifier<bool?> sheetnotifier =
                                    ValueNotifier(null);
                                showLoadingStateSheet(
                                    context: context,
                                    sheetUpdate: sheetnotifier);
                                requestPermissionCourse(
                                        database: database,
                                        category: PermissionAccessType.edit,
                                        courseid: courseInfo.id)
                                    .then((result) {
                                  if (result == true) {
                                    PublicCodeFunctions(
                                            SchulplanerFunctionsBloc.of(
                                                context))
                                        .removePublicCode(
                                            id: courseInfo.id, codetype: 0)
                                        .then((value) {
                                      sheetnotifier.value = value;
                                    });
                                  } else {
                                    print('NOT PERMISSION');
                                    sheetnotifier.value = false;
                                  }
                                });
                              },
                              iconData: Icons.remove_circle_outline),
                      RButton(
                          text: getString(context).sharecode,
                          onTap: () {
                            Share.share(courseInfo.publiccode!);
                          },
                          iconData: Icons.share),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: QRCodeViewPublicCode(publiccode: courseInfo.publiccode),
            )
          ],
        );
      },
      stream: database.courseinfo.getItemStream(courseid),
    );
  }
}
