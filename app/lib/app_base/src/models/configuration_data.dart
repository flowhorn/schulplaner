import 'package:schulplaner8/Data/ConfigurationData.dart';
import 'package:schulplaner8/OldRest/Calendar.dart';

class ConfigurationData {
  final Map<int, int> navigationactions;
  final bool showfavorites;
  final bool smalldevice;
  final CalendarSettings calendarSettings;
  final TimetableSettings timetablesettings;
  final TimelineSettings timelineSettings;
  final int shortname_length;
  final int general_daysinhome;

  const ConfigurationData._({
    required this.navigationactions,
    required this.showfavorites,
    required this.smalldevice,
    required this.calendarSettings,
    required this.shortname_length,
    required this.general_daysinhome,
    required this.timetablesettings,
    required this.timelineSettings,
  });

  factory ConfigurationData.fromData(dynamic data) {
    if (data == null) {
      return ConfigurationData._(
        navigationactions: {},
        showfavorites: false,
        smalldevice: false,
        calendarSettings: CalendarSettings.fromJson(null),
        shortname_length: 2,
        general_daysinhome: 2,
        timetablesettings: TimetableSettings.fromData(null),
        timelineSettings: TimelineSettings.fromData(null),
      );
    } else {
      Map<String, dynamic> premap_navactions =
          data['navigationactions']?.cast<String, int>() ?? {};
      var navactions = premap_navactions.map<int, int>(
          (String key, value) => MapEntry(int.parse(key), value));

      return ConfigurationData._(
        showfavorites: data['showfavorites'] ?? false,
        smalldevice: data['smalldevice'] ?? false,
        shortname_length: data['shortname_length'] ?? 2,
        general_daysinhome: data['general_daysinhome'] ?? 2,
        calendarSettings: CalendarSettings.fromJson(data['cs']),
        timetablesettings: TimetableSettings.fromData(data['timetable']),
        navigationactions: navactions,
        timelineSettings: TimelineSettings.fromData(data['timeline']),
      );
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'showfavorites': showfavorites,
      'smalldevice': smalldevice,
      'shortname_length': shortname_length,
      'general_daysinhome': general_daysinhome,
      'navigationactions': navigationactions
          .map((key, value) => MapEntry(key.toString(), value)),
      'cs': calendarSettings.toJson(),
      'timetable': timetablesettings.toJson(),
      'timeline': timelineSettings.toJson(),
    };
  }

  ConfigurationData copyWith({
    Map<int, int>? navigationactions,
    bool? showfavorites,
    bool? smalldevice,
    CalendarSettings? calendarSettings,
    int? shortname_length,
    int? general_daysinhome,
    TimetableSettings? timetablesettings,
    TimelineSettings? timelineSettings,
  }) {
    return ConfigurationData._(
      navigationactions: navigationactions ?? this.navigationactions,
      showfavorites: showfavorites ?? this.showfavorites,
      smalldevice: smalldevice ?? this.smalldevice,
      calendarSettings: calendarSettings ?? this.calendarSettings,
      shortname_length: shortname_length ?? this.shortname_length,
      general_daysinhome: general_daysinhome ?? this.general_daysinhome,
      timetablesettings: timetablesettings ?? this.timetablesettings,
      timelineSettings: timelineSettings ?? this.timelineSettings,
    );
  }
}
