import 'package:schulplaner_addons/common/model.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

WeekDay weekDayEnumFromString(String data) =>
    enumFromString(WeekDay.values, data)!;

String weekDayEnumToString(WeekDay weekDay) => weekDay.toString().split('.')[1];

enum ProfileDisplayMode { pic, none }

ProfileDisplayMode profileDisplayModeEnumFromString(String data) =>
    enumFromString(ProfileDisplayMode.values, data)!;

String profileDisplayModeEnumToString(ProfileDisplayMode memberRole) =>
    memberRole.toString().split('.')[1];
