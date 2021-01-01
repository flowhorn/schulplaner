import 'package:intl/intl.dart';

class Date {
  final String _iso8601String;

  factory Date(String dateString) {
    return Date._(dateString);
  }

  const Date._(this._iso8601String);

  factory Date.fromDateTime(DateTime dateTime) {
    return Date._(dateTime.toIso8601String().substring(0, 10));
  }

  factory Date.today() => Date.fromDateTime(DateTime.now());

  @override
  int get hashCode => _iso8601String.hashCode;

  @override
  bool operator ==(other) {
    return other is Date && _iso8601String == other._iso8601String;
  }

  bool isAfter(Date other) {
    return _iso8601String.compareTo(other._iso8601String) > 0;
  }

  bool isSameDay(Date other) {
    return _iso8601String == other._iso8601String;
  }

  bool isBefore(Date other) {
    return _iso8601String.compareTo(other._iso8601String) < 0;
  }

  bool isInsideDateRange(Date start, Date end) {
    //CHECKS IF DATE IS AT THE INTERVALL ENDS
    if (isSameDay(start) || isSameDay(end)) return true;
    //CHECKS IF DATE IS BETWEEN START AND END
    return isAfter(start) && isBefore(end);
  }

  int get weekDay => toDateTime.weekday;

  int get weekNumber => getWeekNumber(toDateTime);

  String get toDateString => _iso8601String;

  DateTime get toDateTime => DateTime.parse(_iso8601String);

  DateParser get parser => DateParser(this);

  Date addDays(int days) {
    return Date.fromDateTime(toDateTime.add(Duration(days: days)));
  }
}

class DateParser {
  final Date _date;

  const DateParser(this._date);

  String get toYMMMEd {
    return DateFormat.yMMMEd().format(_date.toDateTime);
  }

  String get toYMMMd {
    return DateFormat.yMMMd().format(_date.toDateTime);
  }

  String get toMMMEd {
    return DateFormat.MMMEd().format(_date.toDateTime);
  }

  String get toYMMMMEEEEd {
    return DateFormat.yMMMMEEEEd().format(_date.toDateTime);
  }
}

int getWeekNumber(DateTime date) {
  final dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
