import 'class_settings.dart';

class PlannerConnections {
  final Map<String, bool> mycourses;
  final Map<String, bool> myclasses;
  final Map<String, ClassSettings> myclasssettings;

  const PlannerConnections({
    required this.mycourses,
    required this.myclasses,
    required this.myclasssettings,
  });

  factory PlannerConnections.fromData(Map<String, dynamic>? data) {
    if (data != null) {
      //datamaps
      Map<String, dynamic> predata_mycourses =
          data['mycourses']?.cast<String, dynamic>() ?? {};
      predata_mycourses.removeWhere((key, value) => value == null);
      final mycourses = predata_mycourses.map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      mycourses.removeWhere((key, value) => value != true);
      Map<String, dynamic> predata_myclasses =
          data['myclasses']?.cast<String, dynamic>() ?? {};
      predata_myclasses.removeWhere((key, value) => value == null);
      final myclasses = predata_myclasses.map<String, bool>(
          (String key, dynamic value) => MapEntry<String, bool>(key, value));
      myclasses.removeWhere((key, value) => value != true);

      Map<String, dynamic> predata_myclasssettings =
          data['myclasssettings']?.cast<String, dynamic>() ?? {};
      predata_myclasssettings.removeWhere((key, value) => value == null);
      final myclasssettings =
          predata_myclasssettings.map<String, ClassSettings>(
        (String key, dynamic value) => MapEntry(
          key,
          ClassSettings.fromData(
            classid: key,
            data: value,
          ),
        ),
      );
      return PlannerConnections(
        mycourses: mycourses,
        myclasses: myclasses,
        myclasssettings: myclasssettings,
      );
    } else {
      return PlannerConnections(
        mycourses: {},
        myclasses: {},
        myclasssettings: {},
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'mycourses': mycourses.map((key, value) => MapEntry(key, true)),
      'myclasses': myclasses.map((key, value) => MapEntry(key, true)),
    };
  }

  bool isCourseActivated(String courseid, String classid) {
    if (myclasssettings[classid]?.disabledcourses.containsKey(courseid) ??
        false) {
      return false;
    } else {
      return true;
    }
  }
}
