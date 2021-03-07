//@dart=2.11
import 'package:meta/meta.dart';
import 'package:schulplaner8/models/helper_functions.dart';

import 'planner_settings.dart';

class SharedSettings {
  final DateTime lastRefreshed;
  final String authorID;
  final PlannerSettingsData settingsData;

  const SharedSettings._({
    @required this.lastRefreshed,
    @required this.authorID,
    @required this.settingsData,
  });

  factory SharedSettings.Create(
      PlannerSettingsData settingsData, String authorID) {
    if (settingsData == null) return null;
    return SharedSettings._(
      authorID: authorID,
      settingsData: settingsData,
      lastRefreshed: DateTime.now(),
    );
  }

  factory SharedSettings.FromData(dynamic data) {
    if (data == null) return null;
    try {
      return SharedSettings._(
        authorID: data['authorID'],
        settingsData: PlannerSettingsData.fromData(data['settingsData']),
        lastRefreshed: dateTimeFromTimestamp(data['lastRefreshed']),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'settingsData': settingsData?.toJson(),
      'lastRefreshed': timestampFromDateTime(lastRefreshed),
    };
  }
}
