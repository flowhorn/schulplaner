import 'package:schulplaner8/holiday_database/models/holiday_type.dart';
import 'package:date/date.dart';
import 'package:meta/meta.dart';
import 'package:schulplaner8/utils/models/errors.dart';
import 'package:schulplaner8/utils/models/id.dart';
import 'package:schulplaner8/utils/models/name.dart';

class Holiday {
  final ID id;
  final Date start, end;
  final Name name;
  final HolidayType type;
  final bool isFromDatabase;

  const Holiday({
    @required this.id,
    @required this.start,
    @required this.end,
    @required this.name,
    @required this.type,
    @required this.isFromDatabase,
  });

  Holiday copyWith({
    ID id,
    Date start,
    end,
    Name name,
    HolidayType type,
    bool isFromDatabase,
  }) {
    return Holiday(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      type: type ?? this.type,
      isFromDatabase: isFromDatabase ?? this.isFromDatabase,
    );
  }
}

class HolidayValidator {
  static bool validate(Holiday holiday) {
    if (holiday.id == null) return false;
    if (holiday.name == null || holiday.name.isEmpty) return false;
    if (holiday.start == null) return false;
    if (holiday.end == null) return false;
    return true;
  }
}

class HolidayConverter {
  static Holiday fromJson(dynamic json, bool isFromDatabase) {
    if (json == null) throw InvalidJsonParseError();
    return Holiday(
      id: ID(json['id']),
      start: Date(json['start']),
      end: Date(json['end']),
      name: Name(json['name']),
      type: holidayTypeFromJson(json['type']),
      isFromDatabase: isFromDatabase,
    );
  }

  static Map<String, dynamic> toJson(Holiday holiday) {
    return {
      'id': holiday.id.key,
      'name': holiday.name.text,
      'start': holiday.start.toDateString,
      'end': holiday.end.toDateString,
      'type': holidayTypeToJson(holiday.type),
    };
  }
}
