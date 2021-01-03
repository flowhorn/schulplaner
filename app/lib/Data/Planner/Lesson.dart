import 'package:flutter/material.dart';
import 'package:schulplaner8/groups/src/models/course.dart';
import 'package:schulplaner8/groups/src/models/place_link.dart';
import 'package:schulplaner8/groups/src/models/teacher_link.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class OverrridenTime {
  String start, end;
  OverrridenTime({this.start, this.end});

  OverrridenTime.fromData(Map<String, dynamic> data) {
    start = data['start'];
    end = data['end'];
  }

  Map<String, dynamic> toJson() {
    if (start == null || end == null) return null;
    return {
      'start': start,
      'end': end,
    };
  }

  OverrridenTime copy() {
    return OverrridenTime(start: start, end: end);
  }
}

class Lesson {
  String courseid, lessonid;
  int day, start, end, weektype;
  TeacherLink teacher;
  PlaceLink place;
  OverrridenTime overridentime;
  bool newimplementation;

  Lesson(
      {this.courseid,
      this.lessonid,
      this.day,
      this.start,
      this.end,
      this.weektype = 0,
      this.teacher,
      this.place,
      this.overridentime,
      this.newimplementation = true});

  factory Lesson.fromData({@required String id, @required dynamic data}) {
    if (data == null) return null;
    return Lesson(
      courseid: data['courseid'],
      lessonid: id,
      day: data['day'],
      start: data['start'],
      end: data['end'],
      weektype: data['weektype'],
      newimplementation: data['newimplementation'] ?? false,
      teacher: data['teacher'] != null
          ? TeacherLink.fromData(id: null, data: data['teacher'])
          : null,
      place: data['place'] != null
          ? PlaceLink.fromData(id: null, data: data['place'])
          : null,
      overridentime: data['overridentime'] != null
          ? OverrridenTime.fromData(
              data['overridentime'].cast<String, dynamic>())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseid': courseid,
      'lessonid': lessonid,
      'day': day,
      'start': start,
      'end': end,
      'newimplementation': newimplementation,
      'weektype': weektype,
      'teacher': teacher?.toJson(),
      'place': place?.toJson(),
      'overridentime': overridentime?.toJson(),
    };
  }

  Map<String, dynamic> toPrimitiveJson(Course courseInfo) {
    return {
      'courseid': courseid,
      'id': lessonid,
      'day': day,
      'start': start,
      'end': end,
      'weektype': weektype,
      'teacher': (teacher ?? courseInfo.getTeacherFirstItem())?.toJson(),
      'location': (place ?? courseInfo.getPlaceFirstItem())?.toJson(),
      'overridentime': overridentime?.toJson(),
    };
  }

  bool isMultiLesson() {
    if (start == null || end == null) return false;
    if (end > start) {
      return true;
    } else {
      return false;
    }
  }

  bool correctWeektype(int checkedtype) {
    if (checkedtype == 0 || weektype == 0 || weektype == null) {
      return true;
    } else {
      return checkedtype == weektype;
    }
  }

  bool validateCreate() {
    if (courseid == null) return false;
    if (day == null) return false;
    if (start == null || end == null) return false;
    if (start > end) return false;
    if (overridentime != null) {
      if (overridentime.start == null && overridentime.end == null) {
      } else {
        if (overridentime.start == null || overridentime.end == null) {
          return false;
        }
        if (overridentime.start.compareTo(overridentime.end) >= 0) return false;
      }
    }
    return true;
  }

  Lesson copy() {
    return Lesson(
      courseid: courseid,
      lessonid: lessonid,
      start: start,
      end: end,
      day: day,
      weektype: weektype,
      teacher: teacher,
      newimplementation: newimplementation,
      place: place,
      overridentime: overridentime?.copy(),
    );
  }

  bool validate() {
    if (courseid == null) return false;
    if (lessonid == null) return false;
    if (day == null) return false;
    if (start == null || end == null) return false;
    if (start > end) return false;
    if (overridentime != null) {
      if (overridentime.start == null && overridentime.end == null) {
      } else {
        if (overridentime.start == null || overridentime.end == null) {
          return false;
        }
        if (overridentime.start.compareTo(overridentime.end) >= 0) return false;
      }
    }
    return true;
  }
}

class WeekType {
  int type;
  String name;
  WeekType({@required this.type, @required this.name});
}

class Weekday {
  int day;
  String name;
  Weekday({@required this.day, @required this.name});
}

Map<int, String> weektypesamount_meaning(BuildContext context) {
  return {
    2: 'AB-Wochen',
    3: 'ABC-Wochen',
    4: 'ABCD-Wochen',
  };
}

Map<int, WeekType> weektypes(BuildContext context) {
  return {
    0: WeekType(type: 0, name: 'Immer'),
    1: WeekType(type: 1, name: 'A-Woche'),
    2: WeekType(type: 2, name: 'B-Woche'),
    3: WeekType(type: 3, name: 'C-Woche'),
    4: WeekType(type: 4, name: 'D-Woche'),
  };
}

List<WeekType> getListOfWeekTypes(
    BuildContext context, PlannerSettingsData settingsdata,
    {bool includealways = true}) {
  Map data = weektypes(context);
  if (!includealways) data.remove(0);
  data.removeWhere((key, _) => key > settingsdata.weektypes_amount);
  return data.values.toList();
}

String getCurrentWeekTypeName(
    BuildContext context, PlannerSettingsData settingsdata) {
  final weektype = settingsdata.getCurrentWeekType();
  if (weektype == 0) return '-';
  return weektypes(context)[weektype].name;
}

Map<int, Weekday> getWeekDays(BuildContext context) {
  return {
    1: Weekday(day: 1, name: getString(context).monday),
    2: Weekday(day: 2, name: getString(context).tuesday),
    3: Weekday(day: 3, name: getString(context).wednesday),
    4: Weekday(day: 4, name: getString(context).thursday),
    5: Weekday(day: 5, name: getString(context).friday),
    6: Weekday(day: 6, name: getString(context).saturday),
    7: Weekday(day: 7, name: getString(context).sunday),
  };
}

List<Weekday> getListOfWeekDaysFull(BuildContext context) {
  Map data = getWeekDays(context);
  return data.values.toList();
}

List<Weekday> getListOfWeekDays(
    BuildContext context, PlannerSettingsData settingsdata) {
  Map data = getWeekDays(context);
  if (!settingsdata.saturday_enabled) data.remove(6);
  if (!settingsdata.sunday_enabled) data.remove(7);
  return data.values.toList();
}
