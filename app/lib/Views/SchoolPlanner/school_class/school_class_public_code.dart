import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/PublicCode.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:share/share.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class SchoolClassPublicCodeView extends StatelessWidget {
  final String classid;
  final PlannerDatabase database;
  SchoolClassPublicCodeView({required this.classid, required this.database});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SchoolClass>(
      builder: (context, snapshot) {
        SchoolClass info = snapshot.data;
        if (info == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (info.publiccode != null && info.joinLink == null) {
          database.requestClassLink(info.id);
        }
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(getString(context).publiccode),
                ),
                ListTile(
                  title: Text(
                    info.publiccode != null
                        ? ('#' + info.publiccode)
                        : ('#??????'),
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text(
                    info.joinLink ?? '???',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.lightBlue,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(info.joinLink);
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    children: <Widget>[
                      if (info.publiccode == null)
                        RButton(
                            text: getString(context).generate,
                            onTap: () {
                              ValueNotifier<bool> sheetnotifier =
                                  ValueNotifier(null);
                              showLoadingStateSheet(
                                  context: context, sheetUpdate: sheetnotifier);
                              requestPermissionClass(
                                      database: database,
                                      category: PermissionAccessType.edit,
                                      classid: classid)
                                  .then((result) {
                                if (result == true) {
                                  generatePublicCode(id: info.id, codetype: 1)
                                      .then((code) {
                                    print(code.toJson());
                                    sheetnotifier.value = code != null;
                                  });
                                } else {
                                  sheetnotifier.value = false;
                                }
                              });
                            },
                            iconData: Icons.refresh),
                      if (info.publiccode != null)
                        RButton(
                            text: getString(context).removecode,
                            onTap: () {
                              ValueNotifier<bool> sheetnotifier =
                                  ValueNotifier(null);
                              showLoadingStateSheet(
                                  context: context, sheetUpdate: sheetnotifier);
                              requestPermissionClass(
                                      database: database,
                                      category: PermissionAccessType.edit,
                                      classid: classid)
                                  .then((result) {
                                if (result == true) {
                                  removePublicCode(id: info.id, codetype: 1)
                                      .then((value) {
                                    sheetnotifier.value =
                                        value != null ? value : false;
                                  });
                                } else {
                                  sheetnotifier.value = false;
                                }
                              });
                            },
                            iconData: Icons.remove_circle_outline),
                      RButton(
                          text: getString(context).sharecode,
                          onTap: () {
                            Share.share(info.publiccode);
                          },
                          iconData: Icons.share),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: QRCodeViewPublicCode(publiccode: info.publiccode),
            )
          ],
        );
      },
      stream: database.schoolClassInfos.getItemStream(classid),
    );
  }
}
