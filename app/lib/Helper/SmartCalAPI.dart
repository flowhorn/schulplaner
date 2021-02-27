// @dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/Planner/Lesson.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/DateAPI.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/OldLessonInfo/LessonInfo.dart';
import 'package:schulplaner8/holiday_database/models/holiday.dart';
import 'package:schulplaner8/models/lesson_time.dart';
import 'package:schulplaner8/models/planner_settings.dart';

List<String> getNextLessons(PlannerDatabase database, String courseid,
    {int count = 3}) {
  PlannerSettingsData settingsData = database.getSettings();
  Iterable<Lesson> alllessons = database
      .getLessons()
      .values
      .where((lesson) => lesson.courseid == courseid);
  List<String> mlist = [];
  if (alllessons.isEmpty) return mlist;
  DateTime theday =
      DateTime.parse(parseDateString(DateTime.now())); //STARTS WITH TODAY

  int attempt = 0;
  while (mlist.length < count && attempt < 100) {
    theday = theday.add(Duration(days: 1));
    attempt++;
    Holiday mVacation = getVacation(theday, database);
    if (mVacation == null) {
      int dayOfWeek = theday.weekday;
      alllessons.forEach((Lesson lesson) {
        if (!mlist.contains(parseDateString(theday))) {
          if (dayOfWeek == lesson.day) {
            if (!settingsData.multiple_weektypes || lesson.weektype == 0) {
              if (isLessonActive(database, lesson.courseid, lesson.lessonid,
                  parseDateString(theday))) mlist.add(parseDateString(theday));
              return;
            } else if (lesson.weektype ==
                getWeektypeofDate(parseDateString(theday), database)) {
              if (isLessonActive(database, lesson.courseid, lesson.lessonid,
                  parseDateString(theday))) mlist.add(parseDateString(theday));
              return;
            }
          }
        }
      });
    }
  }
  return mlist;
}

bool isLessonActive(PlannerDatabase database, String courseid, String lessonid,
    String datestring) {
  Iterable<LessonInfo> elements = database.lessoninfos.data.values.where((it) {
    if (it.courseid != courseid) return false;
    if (it.lessonid != lessonid) return false;
    if (it.date != datestring) return false;
    if (it.type != LessonInfoType.OUT) return false;
    return true;
  });
  if (elements.isNotEmpty) {
    return false;
  } else {
    return true;
  }
}

List<Lesson> getLessonsToday(PlannerDatabase database) {
  DateTime today = DateTime.now();
  int weekday = today.weekday;
  int weektype = database.getSettings().getCurrentWeekType();
  return database.getLessons().values.where((lesson) {
    if (lesson.day != weekday) {
      return false;
    }
    if (lesson.correctWeektype(weektype)) {
      return true;
    } else {
      return false;
    }
  }).toList();
}

String potentialcourseidnow(PlannerDatabase database) {
  TimeOfDay nowtime = TimeOfDay.fromDateTime(DateTime.now());
  Map<int, LessonTime> times = database.getSettings().lessontimes;
  List<Lesson> potential = getLessonsToday(database).where((lesson) {
    String start, end;
    if (lesson?.overridentime?.start != null) {
      start = lesson.overridentime.start;
    }
    if (lesson?.overridentime?.end != null) end = lesson.overridentime.end;

    if (start == null) {
      LessonTime lessonTime = times[lesson.start];
      if (lessonTime?.start != null) {
        start = lessonTime.start;
      }
    }
    if (end == null) {
      LessonTime lessonTime = times[lesson.end];
      if (lessonTime?.end != null) {
        end = lessonTime.end;
      }
    }
    if (start != null && end != null) {
      TimeOfDay starttime = parseTimeOfDay(start);
      TimeOfDay endtime = parseTimeOfDay(end);
      if ((isAfter(starttime, nowtime) || isSame(starttime, nowtime)) &&
          (isBefore(endtime, nowtime) || isSame(endtime, nowtime))) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }).toList();
  if (potential.isNotEmpty) {
    return potential.first.courseid;
  } else {
    return null;
  }
}

bool isBefore(TimeOfDay one, TimeOfDay compare) {
  String onestring = parseTimeString(one);
  String comparestring = parseTimeString(compare);
  if (comparestring.compareTo(onestring) < 0) {
    return true;
  } else {
    return false;
  }
}

bool isSame(TimeOfDay one, TimeOfDay compare) {
  String onestring = parseTimeString(one);
  String comparestring = parseTimeString(compare);
  if (comparestring.compareTo(onestring) == 0) {
    return true;
  } else {
    return false;
  }
}

bool isAfter(TimeOfDay one, TimeOfDay compare) {
  String onestring = parseTimeString(one);
  String comparestring = parseTimeString(compare);
  if (comparestring.compareTo(onestring) > 0) {
    return true;
  } else {
    return false;
  }
}

Holiday getVacation(DateTime datetime, PlannerDatabase database) {
  List<Holiday> vacationlist =
      database.vacations.data.values.where((Holiday v) {
    DateTime vacationstart = v.start.toDateTime;
    DateTime vacationend = v.end.toDateTime;
    if ((vacationstart.isBefore(datetime) ||
                isSameDay(v.start.toDateString,
                    parseDateString(datetime))) //CONDITION 1
            &&
            (vacationend.isAfter(datetime) ||
                isSameDay(v.end.toDateString,
                    parseDateString(datetime))) //CONDITION 2
        ) {
      return true;
    } else {
      return false;
    }
  }).toList();
  if (vacationlist.isNotEmpty) {
    return vacationlist[0];
  } else {
    return null;
  }
}

bool isVacation(DateTime datetime, List<Holiday> vacationlist) {
  List<Holiday> filteredlist = vacationlist.where((Holiday v) {
    DateTime vacationstart = v.start.toDateTime;
    DateTime vacationend = v.end.toDateTime;
    if ((vacationstart.isBefore(datetime) ||
                isSameDay(v.start.toDateString,
                    parseDateString(datetime))) //CONDITION 1
            &&
            (vacationend.isAfter(datetime) ||
                isSameDay(v.end.toDateString,
                    parseDateString(datetime))) //CONDITION 2
        ) {
      return true;
    } else {
      return false;
    }
  }).toList();
  if (filteredlist.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

bool isWeekend(DateTime datetime, PlannerDatabase database) {
  int dayofweek = datetime.weekday;
  PlannerSettingsData mSettings = database.getSettings();
  if (dayofweek == 6 && !mSettings.saturday_enabled) {
    return true;
  } else if (dayofweek == 7 && !mSettings.sunday_enabled) {
    return true;
  } else {
    return false;
  }
}

enum DayTypes {
  SCHOOLDAY,
  VACATION,
  WEEKEND,
}

class DayType {
  DayTypes type;
  String date;
  Holiday vacationItem;
  DayType({this.type, this.date, this.vacationItem});

  bool isSchoolDay() {
    if (type == DayTypes.SCHOOLDAY) {
      return true;
    } else {
      return false;
    }
  }
}

DayType getDayType(String date, PlannerDatabase database) {
  Holiday vacationItem = getVacation(parseDate(date), database);
  if (vacationItem != null) {
    return DayType(
        type: DayTypes.VACATION, date: date, vacationItem: vacationItem);
  } else {
    if (isWeekend(parseDate(date), database)) {
      return DayType(type: DayTypes.WEEKEND, date: date);
    } else {
      return DayType(type: DayTypes.SCHOOLDAY, date: date);
    }
  }
}

int getWeektypeofDate(String datestring, PlannerDatabase database) {
  PlannerSettingsData settingsData = database.getSettings();
  if (settingsData.multiple_weektypes == false) return 0;
  int currentweektype = settingsData.getCurrentWeekType();
  int weektypes = settingsData.weektypes_amount;
  DateTime today = DateTime.parse(getDateToday());
  DateTime MondayofWeekToday = getFirstDayOfWeek(today);
  DateTime MondayofWeekDate = getFirstDayOfWeek(parseDate(datestring));
  Duration difference = MondayofWeekDate.difference(MondayofWeekToday);
  int diffinWeeks = (difference.abs().inDays + 1) ~/ 7;
  int index = currentweektype + (diffinWeeks % weektypes);
  if (index > weektypes) index = index % weektypes;
  return index;
}
