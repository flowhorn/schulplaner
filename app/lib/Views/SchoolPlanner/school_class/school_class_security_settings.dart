import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class SchoolClassSecuritySettings extends StatelessWidget {
  final String classId;
  SchoolClassSecuritySettings({required this.classId});
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return StreamBuilder<SchoolClass?>(
      builder: (context, snapshot) {
        final schoolClass = snapshot.data;
        if (schoolClass == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final design = schoolClass.getDesign();
        return Theme(
            data: newAppThemeDesign(context, design),
            child: Scaffold(
              appBar: MyAppHeader(
                  title:
                      '${getString(context).security} ${getString(context).in_} ' +
                          schoolClass.getName()),
              body: getDefaultList([
                _PublicClass(
                  schoolClass: schoolClass,
                ),
                _EnableChat(
                  schoolClass: schoolClass,
                ),
              ]),
            ));
      },
      stream: database.schoolClassInfos.getItemStream(classId),
    );
  }
}

class _PublicClass extends StatelessWidget {
  final SchoolClass schoolClass;

  const _PublicClass({Key? key, required this.schoolClass}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return SwitchListTile(
      value: schoolClass.settings.isPublic,
      title: Text(bothlang(context,
          de: 'Öffentliche Klasse', en: 'Public school class')),
      onChanged: (newvalue) {
        ValueNotifier<bool?> notifier =
            showPermissionStateSheet(context: context);
        requestPermissionClass(
                database: database,
                category: PermissionAccessType.settings,
                classid: schoolClass.id)
            .then((result) {
          notifier.value = result;
          if (result == true) {
            database.dataManager.getSchoolClassInfo(schoolClass.id).set(
              {
                'settings': {
                  'isPublic': newvalue,
                }
              },
              SetOptions(
                merge: true,
              ),
            );
          }
        });
      },
    );
  }
}

class _EnableChat extends StatelessWidget {
  final SchoolClass schoolClass;

  const _EnableChat({Key? key, required this.schoolClass}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return SwitchListTile(
      value: schoolClass.enablechat,
      title:
          Text(bothlang(context, de: 'Chat aktiviert', en: 'Chat activated')),
      onChanged: (newvalue) {
        ValueNotifier<bool?> notifier =
            showPermissionStateSheet(context: context);
        requestPermissionClass(
                database: database,
                category: PermissionAccessType.settings,
                classid: schoolClass.id)
            .then((result) {
          notifier.value = result;
          if (result == true) {
            database.dataManager.getSchoolClassInfo(schoolClass.id).set(
              {
                'enablechat': newvalue,
              },
              SetOptions(
                merge: true,
              ),
            );
          }
        });
      },
    );
  }
}
