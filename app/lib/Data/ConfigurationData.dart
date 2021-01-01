class TimetableSettings {
  bool centertext, showplace, showgrid, useshortname;
  double heightfactor;

  TimetableSettings(
      {this.centertext = true,
      this.showplace = true,
      this.showgrid = false,
      this.useshortname = false,
      this.heightfactor = 1.0});

  factory TimetableSettings.fromData(dynamic data) {
    if (data == null) {
      return TimetableSettings();
    } else {
      return TimetableSettings(
        centertext: data['centertext'] ?? true,
        showplace: data['showplace'] ?? true,
        showgrid: data['showgrid'] ?? false,
        useshortname: data['useshortname'] ?? false,
        heightfactor: data['heightfactor'] ?? 1.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'centertext': centertext,
      'showplace': showplace,
      'showgrid': showgrid,
      'useshortname': useshortname,
      'heightfactor': heightfactor,
    };
  }
}

class TimelineSettings {
  bool showLessons;

  TimelineSettings({this.showLessons = true});

  factory TimelineSettings.fromData(dynamic data) {
    if (data == null) {
      return TimelineSettings();
    } else {
      return TimelineSettings(
        showLessons: data['showLessons'] ?? true,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'showLessons': showLessons,
    };
  }
}
