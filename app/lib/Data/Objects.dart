import 'package:schulplaner8/Data/plannerdatabase.dart';

class TwoObjects<T, T2> {
  T item;
  T2 item2;
  TwoObjects({required this.item, required this.item2});
}

class ThreeObjects<T, T2, T3> {
  T item;
  T2 item2;
  T3 item3;
  ThreeObjects({required this.item, required this.item2, required this.item3});
}

class CalendarIndicator {
  bool? enabled;
}

class PersonalType {}

class WeekTypeFixPoint {
  late String date;
  late int weektype;
  WeekTypeFixPoint({required this.date, required this.weektype});

  WeekTypeFixPoint.fromData(Map<String, dynamic>? data) {
    if (data != null) {
      date = data['date'];
      weektype = data['weektype'];
    } else {
      date = '2021-01-01';
      weektype = 1;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weektype': weektype,
    };
  }
}

class PlannerConnections {
  late Map<String, bool> mycourses;
  late Map<String, bool> myclasses;
  late Map<String, ClassSettings> myclasssettings;

  PlannerConnections({
    required this.mycourses,
    required this.myclasses,
  });

  PlannerConnections.fromData(Map<String, dynamic>? data) {
    if (data != null) {
      //datamaps
      Map<String, dynamic> predata_mycourses =
          data['mycourses']?.cast<String, dynamic>() ?? {};
      mycourses = predata_mycourses.map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      mycourses.removeWhere((key, value) => value != true);
      Map<String, dynamic> predata_myclasses =
          data['myclasses']?.cast<String, dynamic>() ?? {};
      myclasses = predata_myclasses.map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      myclasses.removeWhere((key, value) => value != true);

      Map<String, dynamic> predata_myclasssettings =
          data['myclasssettings']?.cast<String, dynamic>() ?? {};
      predata_myclasssettings.removeWhere((key, value) => value == null);
      myclasssettings = predata_myclasssettings.map<String, ClassSettings>(
          (String key, dynamic value) =>
              MapEntry(key, ClassSettings.fromData(value, key)));
    } else {
      mycourses = {};
      myclasses = {};

      myclasssettings = {};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'mycourses': mycourses.map((key, value) => MapEntry(key, true)),
      'myclasses': myclasses.map((key, value) => MapEntry(key, true)),
    };
  }

  bool isCourseActivated(String courseid, String classid) {
    if (myclasssettings[classid]?.disabledcourses?.containsKey(courseid) ??
        false) {
      return false;
    } else {
      return true;
    }
  }
}
