import 'package:intl/intl.dart';

class DateUtils {
  static String parseDateString(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 10);
  }

  static DateTime parseDateTime(String dateString) {
    return DateTime.parse(dateString);
  }

  static String getDateText(String dateString) {
    return DateFormat.yMMMd("de").format(parseDateTime(dateString));
  }
}
