import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Objects.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner8/grades/models/default_grade_profile.dart';
import 'package:schulplaner8/grades/models/grade_profile.dart';
import 'package:schulplaner8/grades/models/grade_type_item.dart';
import 'package:schulplaner8/utils/models/coder.dart';

import 'lesson_time.dart';

class PlannerSettingsData {
  bool saturday_enabled,
      sunday_enabled,
      zero_lesson,
      multiple_weektypes,
      timetable_timemode;
  int maxlessons, weektypes_amount;
  WeekTypeFixPoint weekTypeFixPoint;
  //datamaps
  Map<int, LessonTime> lessontimes;
  Map<int, CalendarIndicator> calendarindicators;
  Map<String, GradeProfile> gradeprofiles;
  Map<String, GradeSpan> gradespans;

  //data
  String vacationpackageid, gradedataid;

  //GRADES:::
  AverageSettings averageSettings;
  bool weight_tendencies;
  int gradepackageid = 2;
  int average_display_id;
  //personaltypes
  Map<String, PersonalType> personaltypes_task;
  Map<String, PersonalType> personaltypes_event;
  Map<String, PersonalType> personaltypes_grade;

  PlannerSettingsData.fromData(dynamic data) {
    if (data != null) {
      zero_lesson = data['zero_lesson'] ?? false;
      maxlessons = data['maxlessons'] ?? data['maxlesson'] ?? 12;
      timetable_timemode = data['timetable_timemode'] ?? false;
      weektypes_amount = data['weektypes_amount'] ?? data['weektypes'] ?? 2;
      saturday_enabled =
          data['saturday_enabled'] ?? data['schedule_saturday'] ?? false;
      multiple_weektypes = data['multiple_weektypes'] ?? false;
      sunday_enabled =
          data['sunday_enabled'] ?? data['schedule_sunday'] ?? false;
      weekTypeFixPoint = data['weektype_fixpoint'] != null
          ? WeekTypeFixPoint.fromData(
              data['weektype_fixpoint']?.cast<String, dynamic>())
          : WeekTypeFixPoint(date: '2019-01-01', weektype: 1);
      //data
      vacationpackageid = data['vacationpackageid'];
      gradedataid = data['gradedataid'];

      //datamaps
      Map<String, dynamic> predata_lessontimes =
          data['lessontimes']?.cast<String, dynamic>();

      lessontimes = (predata_lessontimes ?? {}).map<int, LessonTime>(
          (String key, dynamic value) => MapEntry<int, LessonTime>(
              int.parse(key),
              LessonTime.fromData(value.cast<String, dynamic>())));

      Map<String, dynamic> predata_gradespans =
          data['gradespans']?.cast<String, dynamic>();

      gradespans = (predata_gradespans ?? {}).map<String, GradeSpan>(
          (String key, dynamic value) => MapEntry<String, GradeSpan>(
              key, GradeSpan.fromData(value.cast<String, dynamic>())));

      gradeprofiles = decodeMap(
          data['gradeprofiles'], (key, value) => GradeProfile.fromData(value));
      if (gradeprofiles['default'] == null) {
        gradeprofiles['default'] = defaulgradeprofile;
      }

      try {
        if (gradeprofiles['default'].types['1'] != null &&
            gradeprofiles['default'].types['1'].id == '0') {
          Map<String, GradeTypeItem> datamap = gradeprofiles['default'].types;
          datamap['1'] = datamap['1'].copyWith(id: '1');
          gradeprofiles['default'] =
              gradeprofiles['default'].copyWith(types: datamap);
        }
      } catch (e) {
        print(e);
      }

      weight_tendencies = data['weight_tendencies'] ?? true;
      average_display_id = data['average_display_id'] ?? 0;
      gradepackageid = data['grade_type'] ?? 1;
    } else {
      maxlessons = 12;
      weektypes_amount = 2;
      multiple_weektypes = false;
      zero_lesson = false;
      saturday_enabled = false;
      sunday_enabled = false;
      timetable_timemode = false;
      weekTypeFixPoint = WeekTypeFixPoint(date: '2019-01-01', weektype: 1);
      lessontimes = {
        1: LessonTime(start: '8:00', end: '9:00'),
        2: LessonTime(start: '9:00', end: '10:00'),
        3: LessonTime(start: '10:00', end: '11:00'),
        4: LessonTime(start: '11:00', end: '12:00'),
        5: LessonTime(start: '12:00', end: '13:00'),
        6: LessonTime(start: '13:00', end: '14:00'),
        7: LessonTime(start: '14:00', end: '15:00'),
        8: LessonTime(start: '15:00', end: '16:00'),
      };
      gradespans = {};
      gradeprofiles = {
        'default': defaulgradeprofile,
      };
      weight_tendencies = true;
      average_display_id = 0;
      gradepackageid = 1;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'zero_lesson': zero_lesson,
      'maxlessons': maxlessons,
      'saturday_enabled': saturday_enabled,
      'sunday_enabled': sunday_enabled,
      'weektypes_amount': weektypes_amount,
      'multiple_weektypes': multiple_weektypes,
      'timetable_timemode': timetable_timemode,
      'weektype_fixpoint': weekTypeFixPoint?.toJson(),
      //data
      'vacationpackageid': vacationpackageid,
      'gradedataid': gradedataid,

      //datamaps
      'lessontimes': lessontimes
          ?.map((key, value) => MapEntry(key.toString(), value?.toJson())),
      'gradespans': gradespans
          ?.map((key, value) => MapEntry(key.toString(), value?.toJson())),

      //GRADES::
      'weight_tendencies': weight_tendencies,
      'grade_type': gradepackageid,
      'gradeprofiles':
          gradeprofiles.map((key, value) => MapEntry(key, value?.toJson())),
      'average_display_id': average_display_id,
    };
  }

  GradeProfile getGradeProfile(String profileid) {
    if (profileid == null) return gradeprofiles['default'];
    var item = gradeprofiles[profileid];
    return item ?? gradeprofiles['default'];
  }

  PlannerSettingsData copy() {
    return PlannerSettingsData.fromData(toJson());
  }

  int getAmountDaysOfWeek() {
    int amountdays = 5;
    if (saturday_enabled) amountdays++;
    if (sunday_enabled) amountdays++;
    return amountdays;
  }

  int getCurrentWeekType() {
    if (weekTypeFixPoint.date == null || weekTypeFixPoint.weektype == null) {
      return 0;
    }
    if (multiple_weektypes == false) return 0;
    DateTime mondayOfToday = getFirstDayOfWeek(DateTime.parse(getDateToday()));
    DateTime mondayOfFixPoint =
        getFirstDayOfWeek(DateTime.parse(weekTypeFixPoint?.date));
    Duration difference = mondayOfFixPoint.difference(mondayOfToday);
    int diffinWeeks = (difference.abs().inDays + 1) ~/ 7;
    int index = weekTypeFixPoint.weektype + (diffinWeeks % weektypes_amount);
    if (index > weektypes_amount) index = index % weektypes_amount;
    return index;
  }

  int getAmountWeekTypes() {
    if (multiple_weektypes == false) return 1;
    return weektypes_amount;
  }

  GradePackage getCurrentGradePackage({BuildContext context}) {
    return getGradePackage(gradepackageid, context: context);
  }

  AverageDisplay getCurrentAverageDisplay({BuildContext context}) {
    GradePackage package = getCurrentGradePackage(context: context);
    print(average_display_id);
    if (package.averagedisplays.length > 1) {
      if ((package.averagedisplays.length) > average_display_id) {
        return package.averagedisplays[average_display_id];
      } else {
        return package.averagedisplays.first;
      }
    } else {
      return package.averagedisplays.first;
    }
  }

  @override
  bool operator ==(other) {
    return other is PlannerSettingsData &&
        jsonEncode(toJson()) == jsonEncode(other.toJson());
  }
}
