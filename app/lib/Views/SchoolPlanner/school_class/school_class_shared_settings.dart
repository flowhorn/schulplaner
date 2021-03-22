import 'package:flutter/material.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner8/Helper/PermissionManagement.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/models/school_class.dart';
import 'package:schulplaner8/models/shared_settings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:schulplaner_widgets/schulplaner_common.dart';

class SchoolClassSharedSettingsView extends StatelessWidget {
  final String schoolClassID;
  final PlannerDatabase database;
  SchoolClassSharedSettingsView({
    required this.schoolClassID,
    required this.database,
  }) {
    timeago.setLocaleMessages('de', timeago.DeMessages());
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SchoolClass?>(
      builder: (context, snapshot) {
        SchoolClass? schoolClassInfo = snapshot.data;
        if (schoolClassInfo == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final Design? courseDesign = schoolClassInfo.getDesign();
        final SharedSettings? sharedSettings = schoolClassInfo.sharedSettings;
        return Theme(
            data: newAppThemeDesign(context, courseDesign),
            child: Scaffold(
              appBar: MyAppHeader(
                  title: bothlang(context,
                      de: 'Geteilte Einstellungen', en: 'Shared Settings')),
              body: Column(
                children: <Widget>[
                  if (sharedSettings == null)
                    ListTile(
                      title: Text(bothlang(
                        context,
                        de: 'Keine Einstellungen geteilt',
                        en: 'No shared settings',
                      )),
                    ),
                  if (sharedSettings != null)
                    StreamBuilder<PlannerSettingsData?>(
                      stream: database.settings.stream,
                      builder: (context, snapshot) {
                        PlannerSettingsData? currentSettings = snapshot.data;

                        bool enabled =
                            !(currentSettings == sharedSettings.settingsData);

                        return ListTile(
                          title: Text(
                            bothlang(context,
                                    en: 'Last refreshed: ',
                                    de: 'Zuletzt aktualisiert: ') +
                                (sharedSettings.lastRefreshed != null
                                    ? timeago.format(
                                        sharedSettings.lastRefreshed!,
                                        locale: getString(context).languagecode)
                                    : '/'),
                          ),
                          trailing: RButton(
                            iconData: Icons.file_download,
                            enabled: enabled,
                            text: bothlang(
                              context,
                              de: 'Übernehemen',
                              en: 'Apply',
                            ),
                            onTap: !enabled
                                ? null
                                : () {
                                    database.dataManager.UpdateSettings(
                                        sharedSettings.settingsData!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(getString(context).refreshed),
                                      ),
                                    );
                                  },
                          ),
                        );
                      },
                    ),
                  RButton(
                    iconData: Icons.share,
                    text: getString(context).share,
                    onTap: () {
                      requestSimplePermission(
                        database: database,
                        context: context,
                        type: 1,
                        id: schoolClassInfo.id,
                        category: PermissionAccessType.edit,
                      ).then(
                        (result) {
                          if (result == true) {
                            database.dataManager
                                .UpdateSchoolClassSharedSettings(
                              schoolClassID,
                              SharedSettings.Create(
                                database.getSettings(),
                                database.getMemberId(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ));
      },
      stream: database.schoolClassInfos.getItemStream(schoolClassID),
    );
  }
}
