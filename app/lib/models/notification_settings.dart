//
import 'package:universal_commons/platform_check.dart';
import 'package:date/time.dart';

String getDeviceName() {
  //DeviceInfoPlugin plugin =DeviceInfoPlugin();
  if (PlatformCheck.isAndroid) {
    return 'Android Gerät';
  } else if (PlatformCheck.isIOS) {
    return 'iOS Gerät';
  } else {
    return 'Unbekannter Gerätetyp';
  }
}

class NotificationDevice {
  String? devicetoken;
  bool? enabled;
  String? devicename;
  NotificationDevice({this.devicetoken, this.enabled, this.devicename});

  NotificationDevice.fromData(String token, Map<String, dynamic> data) {
    devicetoken = token;
    enabled = data['enabled'];
    devicename = data['devicename'];
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'devicename': devicename,
    };
  }
}

class NotificationSettings {
  late bool notifycreatetasks, notifydaily, notifyassist;
  late Time? dailyNotificationTime;
  late int dailydaterange;
  late Map<String, NotificationDevice?> devices;

  NotificationSettings.fromData(Map<String, dynamic>? data) {
    if (data == null) {
      notifycreatetasks = false;
      notifydaily = false;
      notifyassist = false;
      dailyNotificationTime = null;
      dailydaterange = 1;
      devices = {};
    } else {
      notifycreatetasks = data['notifycreatetasks'] ?? false;
      notifydaily = data['notifydaily'] ?? false;
      notifyassist = data['notifyassist'] ?? false;
      dailyNotificationTime =
          data['dailytime'] == null ? null : Time.parse(data['dailytime']);
      dailydaterange = data['dailydaterange'] ?? 1;

      //DATAMAPS:
      Map<String, dynamic> premapdevices =
          data['devices']?.cast<String, dynamic>() ?? {};
      premapdevices.removeWhere((key, value) => value == null);
      devices = premapdevices.map<String, NotificationDevice>(
          (String key, value) => MapEntry(
              key,
              NotificationDevice.fromData(
                  key, value?.cast<String, dynamic>())));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'notifycreatetasks': notifycreatetasks,
      'notifydaily': notifydaily,
      'notifyassist': notifyassist,
      'dailytime': dailyNotificationTime.toString(),
      'dailydaterange': dailydaterange,
      'devices': devices.map((key, value) => MapEntry(key, value?.toJson())),
    };
  }
}
