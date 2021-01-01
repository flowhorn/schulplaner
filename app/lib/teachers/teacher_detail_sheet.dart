import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/Views/SchoolPlanner/Teachers.dart';
import 'package:schulplaner8/groups/src/models/teacher.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:url_launcher/url_launcher.dart';

showTeacherDetail(
    {@required BuildContext context,
    @required PlannerDatabase plannerdatabase,
    @required String teacherid}) {
  showDetailSheetBuilder(
      context: context,
      body: (BuildContext context) {
        return StreamBuilder<Teacher>(
            stream: plannerdatabase.teachers.getItemStream(teacherid),
            builder: (BuildContext context, snapshot) {
              Teacher item = snapshot.data;
              if (item == null) return loadedView();
              return Column(
                children: <Widget>[
                  getSheetText(context, item.name),
                  FormSpace(12.0),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(item.tel ?? "-"),
                  ),
                  ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: Text(item.email ?? "-"),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ButtonBar(
                      children: <Widget>[
                        RButton(
                            text: "Anrufen",
                            onTap: () {
                              if (item.tel != null) {
                                launch("tel:" + item.tel);
                              }
                            }),
                        RButton(
                            text: "E-Mail Schreiben",
                            onTap: () {
                              if (item.email != null) {
                                launch("mailto:" + item.email);
                              }
                            }),
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
                                                NewTeacherView(
                                                  database: plannerdatabase,
                                                  editMode: true,
                                                  editteacherid: item.teacherid,
                                                ));
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete_outline),
                                          title:
                                              Text(getString(context).delete),
                                          onTap: () {
                                            showConfirmDialog(
                                                    context: context,
                                                    title: getString(context)
                                                        .delete,
                                                    action: getString(context)
                                                        .delete,
                                                    richtext: null)
                                                .then((result) {
                                              if (result == true) {
                                                plannerdatabase.dataManager
                                                    .DeleteTeacher(item);
                                                Navigator.popUntil(context,
                                                    (Route predicate) {
                                                  return (predicate
                                                              ?.settings?.name
                                                              ?.startsWith(
                                                                  "teacherid") ??
                                                          false) ==
                                                      false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  title: getString(context).more,
                                  routname: "teacheridmore");
                            },
                            iconData: Icons.more_horiz),
                      ],
                    ),
                  ),
                ],
              );
            });
      },
      routname: "teacheridview");
}
