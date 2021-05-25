import 'package:schulplaner8/utils/models/coder.dart';

enum HolidayType {
  holiday,
}

HolidayType holidayTypeFromJson(String? json) =>
    enumFromJson<HolidayType>(HolidayType.values, json,
        orElse: HolidayType.holiday);

String? holidayTypeToJson(HolidayType holidayType) =>
    enumToJson<HolidayType>(holidayType);
