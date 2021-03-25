//
import 'package:date/time.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    as firebase_messaging;
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/app_base/src/blocs/planner_database_bloc.dart';
import 'package:schulplaner8/models/notification_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'package:universal_commons/platform_check.dart';

class NotificationSettingsSubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = PlannerDatabaseBloc.getDatabase(context);
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).notifications,
      ),
      body: StreamBuilder<NotificationSettings>(
        stream: database.dataManager.notificationSettings.snapshots().map(
          (snapshot) {
            return NotificationSettings.fromData(snapshot.data());
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notificationSettings = snapshot.data;
            return _Inner(notificationSettings: notificationSettings!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void _updateNotificationSettings(
    BuildContext context, NotificationSettings newSettings) {
  final database = PlannerDatabaseBloc.getDatabase(context);
  database.dataManager.notificationSettings.set(newSettings.toJson());
}

class _Inner extends StatelessWidget {
  final NotificationSettings notificationSettings;

  const _Inner({Key? key, required this.notificationSettings})
      : super(key: key);

  Future<bool> getWebInitFuture() async {
    if (PlatformCheck.isWeb) {
      final messaging = firebase_messaging.FirebaseMessaging.instance;
      await messaging.getToken(
        vapidKey:
            'BE1bPoqMt335BxnwYC3F6JtaYU7zZdew4wRSLKWrbSVyaGcJ5VAtKDl-9FScF-ru657ZnGDJrNqtKRb-8eZs1G8',
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getWebInitFuture(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SwitchListTile(
                  value: notificationSettings.notifycreatetasks,
                  onChanged: (newvalue) {
                    notificationSettings.notifycreatetasks = newvalue;
                    _updateNotificationSettings(context, notificationSettings);
                  },
                  title: Text(getString(context).createnotifications),
                ),
                SwitchListTile(
                  value: notificationSettings.notifydaily,
                  onChanged: (newvalue) {
                    notificationSettings.notifydaily = newvalue;
                    _updateNotificationSettings(context, notificationSettings);
                  },
                  title: Text(getString(context).dailynotifications),
                ),
                ListTile(
                  title: Text(getString(context).timetoremember),
                  subtitle: Text(notificationSettings.dailyNotificationTime !=
                          null
                      ? getTimeOfUTC(notificationSettings.dailyNotificationTime)
                          .format(context)
                      : '-'),
                  enabled: notificationSettings.notifydaily,
                  onTap: notificationSettings.notifydaily
                      ? () {
                          showTimePicker(
                                  context: context,
                                  initialTime: notificationSettings
                                              .dailyNotificationTime !=
                                          null
                                      ? getTimeOfUTC(notificationSettings
                                          .dailyNotificationTime)
                                      : TimeOfDay(hour: 16, minute: 0))
                              .then((TimeOfDay? newTime) {
                            if (newTime != null) {
                              Time localTime = Time.fromTimeOfDay(newTime);
                              Time utcTime = getUTCTimeOfLocal(localTime);
                              // Da nur volle Stunden erlaubt sind.
                              notificationSettings.dailyNotificationTime =
                                  utcTime.copyWithAddedMinutes(-utcTime.minute);
                              _updateNotificationSettings(
                                  context, notificationSettings);

                              // SHOW USER THAT SELECTED TIME IS CHANGED TO FULLTIME
                              var resultsheet = showResultStateSheet(
                                  context: context, fontSize: 15.5);
                              resultsheet.value = ResultItem(
                                  loading: false,
                                  iconData: Icons.warning,
                                  color: Colors.orange,
                                  text: bothlang(context,
                                      de: 'Die Funktion befindet sich aktuell noch in der BETA. Alle Zeiten werden auf volle Stunden gerundet.',
                                      en: 'This feature is still in the BETA. All times are rounded to full hours.'));
                            }
                          });
                        }
                      : null,
                  trailing: Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('BETA'),
                    ),
                    color: Colors.orange,
                  ),
                ),
                ListTile(
                  title: Text(getString(context).rememberdaysbefore),
                  subtitle: Text(notificationSettings.dailydaterange != null
                      ? (notificationSettings.dailydaterange.toString() +
                          ' ' +
                          getString(context).days)
                      : '-'),
                  enabled: notificationSettings.notifydaily,
                  onTap: notificationSettings.notifydaily
                      ? () {
                          selectItem<int>(
                              context: context,
                              items: buildIntList(7, start: 1),
                              builder: (context, item) {
                                return ListTile(
                                  title: Text(item.toString() +
                                      ' ' +
                                      getString(context).days),
                                  trailing: selectedView(item ==
                                      notificationSettings.dailydaterange),
                                  onTap: () {
                                    notificationSettings.dailydaterange = item;
                                    _updateNotificationSettings(
                                        context, notificationSettings);
                                    Navigator.pop(context);
                                  },
                                );
                              });
                        }
                      : null,
                ),
                FormDivider(),
                FormHeader(getString(context).devices),
                Column(
                  children: notificationSettings.devices.values.map((device) {
                    if (device == null) return nowidget();
                    return ListTile(
                      leading: ColoredCircleIcon(
                        color: getAccentColor(context),
                        icon: Icon(Icons.devices),
                      ),
                      title: Text(device.devicename ?? '-'),
                      subtitle: Text(
                        device.devicetoken.toString() ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            notificationSettings.devices[device.devicetoken!] =
                                null;
                            _updateNotificationSettings(
                                context, notificationSettings);
                          }),
                    );
                  }).toList(),
                ),
                FormSpace(12.0),
                _Devices(
                  notificationSettings: notificationSettings,
                ),
                FormDivider(),
                FormSpace(64.0),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          );
        });
  }
}

class _Devices extends StatelessWidget {
  final NotificationSettings notificationSettings;

  const _Devices({Key? key, required this.notificationSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (notificationSettings.devices.containsKey(snapshot.data)) {
            return ListTile(
              title: Text(
                getString(context).thisdeviceisactive + ' :)',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return FloatingActionButton.extended(
              onPressed: () {
                final newdevice = NotificationDevice(
                  devicetoken: snapshot.data,
                  enabled: true,
                  devicename: getDeviceName(),
                );
                notificationSettings.devices[newdevice.devicetoken!] =
                    newdevice;
                _updateNotificationSettings(context, notificationSettings);
              },
              icon: Icon(Icons.devices),
              label: Text(getString(context).addthisdevice),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
      future: PlatformCheck.isMobile
          ? firebase_messaging.FirebaseMessaging.instance.getToken()
          : Future.value(null),
    );
  }
}
