// @dart=2.11
import 'package:bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date/time.dart';
import 'package:schulplaner8/app_base/src/blocs/app_settings_bloc.dart';
import 'package:schulplaner8/app_base/src/models/app_settings_data.dart';
import 'package:schulplaner8/app_base/src/models/configuration_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

typedef T1 DynamicObjectBuilder<T1>(dynamic decodedMapValue);

String getDateString(String date) {
  return DateFormat.yMMMMEEEEd('de').format(DateTime.parse(date));
}

String getDateStringSmall(String date) {
  return DateFormat.yMMMd('de').format(DateTime.parse(date));
}

String parseDatetime(DateTime date) {
  return DateFormat.yMMMMEEEEd('de').format(date);
}

Map<String, dynamic> decodeMapNullable(dynamic data) {
  Map<dynamic, dynamic> premapdata = data?.cast<String, dynamic>();
  return (premapdata ?? {}).map<String, dynamic>(
      (dynamic key, dynamic value) => MapEntry<String, dynamic>(key, value));
}

Map<String, T1> buildDataMapNullable<T1>(
    dynamic data, DynamicObjectBuilder<T1> builder) {
  return decodeMapNullable(data).map((key, value) =>
      value != null ? MapEntry(key, builder(value)) : MapEntry(key, null));
}

Timestamp buildTimestamp(dynamic data) {
  try {
    return data;
  } catch (e) {
    return Timestamp.fromDate(data);
  }
}

TimeOfDay parseTimeOfDay(String timestring) {
  if (timestring == null) return TimeOfDay.now();
  return TimeOfDay(
      hour: int.parse(timestring.split(':')[0]),
      minute: int.parse(timestring.split(':')[1]));
}

String parseTimeString(TimeOfDay time) {
  NumberFormat format = NumberFormat(
    '00',
  );
  return format.format(time.hour) + ':' + format.format(time.minute);
}

String parseDateToday() => parseDatetime(DateTime.now());

String useOr(String s1, String s2) {
  if (s1 == null || s1 == '') {
    return s2;
  } else {
    return s1;
  }
}

String getGenderName(int gender) {
  switch (gender) {
    case 0:
      return 'Männlich';
    case 1:
      return 'Weiblich';
    default:
      return 'Keine Angaben';
  }
}

List<int> buildIntList(int length, {int start = 0}) {
  List<int> newlist = [];
  for (int i = start; i <= length; i++) {
    newlist.add(i);
  }
  return newlist;
}

TimeOfDay getTimeOfDay(String time) {
  return TimeOfDay(
    hour: time != null ? int.parse(time.split(':')[0]) : 12,
    minute: time != null ? int.parse(time.split(':')[1]) : 0,
  );
}

TimeOfDay getTimeOfUTC(Time time) {
  DateTime utcTime = DateTime.utc(
    2018,
    1,
    1,
    time != null ? time.hour : 12,
    time != null ? time.minute : 0,
  );
  DateTime localTime = utcTime.toLocal();
  return TimeOfDay(
    hour: localTime.hour,
    minute: localTime.minute,
  );
}

Time getUTCTimeOfLocal(Time time) {
  final localTime = DateTime(
    2018,
    1,
    1,
    time != null ? time.hour : 12,
    time != null ? time.minute : 0,
  );
  final utcTime = localTime.toUtc();
  final timeOfDay = TimeOfDay(
    hour: utcTime.hour,
    minute: utcTime.minute,
  );
  return Time.fromTimeOfDay(timeOfDay);
}

AppSettingsData getAppSettings(BuildContext context) {
  return BlocProvider.of<AppSettingsBloc>(context)?.currentValue ??
      AppSettingsData.fromString(null);
}

ConfigurationData getConfigurationData(BuildContext context) {
  return getAppSettings(context).configurationData;
}

String bothlang(BuildContext context,
    {@required String de, @required String en}) {
  if (getString(context).languagecode == 'de') {
    return de;
  } else {
    return en;
  }
}
