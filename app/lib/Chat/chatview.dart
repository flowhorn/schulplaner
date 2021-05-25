import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schulplaner8/Chat/chatThread.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/models/coursepermission.dart';
import 'package:schulplaner8/models/school_class.dart';

class Chat extends StatelessWidget {
  final String groupid;
  final String uid;
  final PlannerDatabase database;
  final Design design;

  const Chat(
    this.database,
    this.design, {
    required this.groupid,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: newAppThemeDesign(context, design),
        child: Scaffold(
          appBar: MyAppHeader(
            title: getString(context).chat,
          ),
          body: StreamBuilder<SchoolClass?>(
              initialData: database.getClassInfo(groupid),
              stream: database.schoolClassInfos.getItemStream(groupid),
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return CircularProgressIndicator();
                if (data.enablechat) {
                  return ChatThread(
                    database: database,
                    groupid: groupid,
                    uid: uid,
                  );
                } else {
                  return Center(
                    child: Column(
                       mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            getString(context).adminenablechat,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Switch(
                            value: data.enablechat,
                            onChanged: (newvalue) {
                              requestSimplePermission(
                                      context: context,
                                      database: database,
                                      category: PermissionAccessType.settings,
                                      id: groupid,
                                      type: 1)
                                  .then((result) {
                                if (result == true) {
                                  database.dataManager
                                      .schoolClassRoot(groupid)
                                      .set(
                                    {'enablechat': newvalue},
                                    SetOptions(merge: true),
                                  );
                                }
                              });
                            })
                      ],
                     
                    ),
                  );
                }
              }),
        ));
  }
}
