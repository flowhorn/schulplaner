import 'package:schulplaner8/Data/plannerdatabase.dart';

class TwoObjects<T, T2> {
  T item;
  T2 item2;
  TwoObjects({this.item, this.item2});
}

class ThreeObjects<T, T2, T3> {
  T item;
  T2 item2;
  T3 item3;
  ThreeObjects({this.item, this.item2, this.item3});
}

class CalendarIndicator {
  bool enabled;
}

class PersonalType {}

class WeekTypeFixPoint {
  String date;
  int weektype;
  WeekTypeFixPoint({this.date, this.weektype});

  WeekTypeFixPoint.fromData(Map<String, dynamic> data) {
    if (data != null) {
      date = data['date'];
      weektype = data['weektype'];
    } else {
      date = data['2019-01-01'];
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
  Map<String, bool> mycourses;
  Map<String, bool> myclasses;
  Map<String, bool> myschools;
  Map<String, ClassSettings> myclasssettings;

  PlannerConnections({this.mycourses, this.myclasses, this.myschools});

  PlannerConnections.fromData(Map<String, dynamic> data) {
    if (data != null) {
      //datamaps
      Map<String, dynamic> predata_mycourses =
          data['mycourses']?.cast<String, dynamic>();
      mycourses = (predata_mycourses ?? {}).map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      mycourses?.removeWhere((key, value) => value != true);
      Map<String, dynamic> predata_myclasses =
          data['myclasses']?.cast<String, dynamic>();
      myclasses = (predata_myclasses ?? {}).map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      myclasses?.removeWhere((key, value) => value != true);
      myschools = {};

      Map<String, dynamic> predata_myclasssettings =
          data['myclasssettings']?.cast<String, dynamic>();
      predata_myclasssettings?.removeWhere((key, value) => value == null);
      myclasssettings = (predata_myclasssettings ?? {})
          .map<String, ClassSettings>((String key, dynamic value) =>
              MapEntry(key, ClassSettings.fromData(value, key)));
    } else {
      mycourses = {};
      myclasses = {};
      myschools = {};
      myclasssettings = {};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'mycourses': mycourses.map((key, value) => MapEntry(key, true)),
      'myclasses': myclasses.map((key, value) => MapEntry(key, true)),
      'myschools': myschools.map((key, value) => MapEntry(key, true)),
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
