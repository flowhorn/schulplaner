import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

String parseDateString(DateTime time) {
  return DateFormat('yyyy-MM-dd').format(time);
}

DateTime parseDate(String datestring) {
  return DateTime.parse(datestring);
}

String getDateText(String datestring) {
  DateTime dateTime = parseDate(datestring);
  return DateFormat.yMMMMEEEEd().format(dateTime);
}

String getDateNoWeekDayText(String datestring) {
  DateTime dateTime = parseDate(datestring);
  return DateFormat.yMMMMd().format(dateTime);
}

String getDateTextDetailed(
  BuildContext context,
  DateTime datetime,
) {
  Duration difference = datetime.difference(DateTime.now()).abs();
  if (difference.inMinutes < 2) return getString(context).justnow;
  if (difference.inHours < 1) {
    int minutesago = difference.inMinutes;
    return bothlang(context,
        de: 'Vor $minutesago Minuten', en: '$minutesago minutes ago');
  }
  if (difference.inHours == 1) {
    int hoursago = difference.inHours;
    return bothlang(context,
        de: 'Vor $hoursago Stunde', en: '$hoursago hour ago');
  }
  if (difference.inHours <= 8) {
    int hoursago = difference.inHours;
    return bothlang(context,
        de: 'Vor $hoursago Stunden', en: '$hoursago hours ago');
  }
  if (isSameDay(parseDateString(datetime), getDateToday())) {
    return getString(context).today;
  }
  if (isSameDay(parseDateString(datetime), getDateYesterday())) {
    return getString(context).yesterday;
  }
  return DateFormat.yMMMMEEEEd().format(datetime);
}

String getDateTextShort2(String datestring) {
  DateTime dateTime = parseDate(datestring);
  return DateFormat.yMd().format(dateTime);
}

String getDateTextShort(String datestring) {
  DateTime dateTime = parseDate(datestring);
  return DateFormat.MMMEd().format(dateTime);
}

String getDateToday() {
  return parseDateString(DateTime.now().add(Duration(days: 0)));
}

String getDateYesterday() {
  return parseDateString(DateTime.now().subtract(Duration(days: 1)));
}

String getDateTomorrow() {
  return parseDateString(DateTime.now().add(Duration(days: 1)));
}

String getDateInXDays(int days) {
  return parseDateString(DateTime.now().add(Duration(days: days)));
}

String getDateOneWeekAgo() {
  return parseDateString(DateTime.now().subtract(Duration(days: 7)));
}

String getDateTwoWeeksAgo() {
  return parseDateString(DateTime.now().subtract(Duration(days: 14)));
}

DateTime getFirstDayOfWeek(DateTime datetime) {
  return datetime.subtract(Duration(days: datetime.weekday - 1));
}

bool isToday(DateTime datetime) {
  return parseDateString(datetime) == parseDateString(DateTime.now());
}

bool isInNextXDays(String date, int days) {
  String datetoday = getDateToday();
  String datex = getDateInXDays(days);
  if (isSameDay(date, datetoday)) return true;
  if (date.compareTo(datetoday) < 0) {
    return false;
  } else {
    if (date.compareTo(datex) < 0) {
      return true;
    } else {
      return false;
    }
  }
}

bool isSameDay(String date1, String date2) {
  if (date1 == date2) {
    return true;
  } else {
    return false;
  }
}
