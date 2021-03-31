import 'package:schulplaner8/models/helper_functions.dart';
import 'planner_settings.dart';

class SharedSettings {
  final DateTime? lastRefreshed;
  final String authorID;
  final PlannerSettingsData? settingsData;

  const SharedSettings._({
    required this.lastRefreshed,
    required this.authorID,
    required this.settingsData,
  });

  factory SharedSettings.Create(
      PlannerSettingsData settingsData, String authorID) {
    return SharedSettings._(
      authorID: authorID,
      settingsData: settingsData,
      lastRefreshed: DateTime.now(),
    );
  }

  factory SharedSettings.FromData(dynamic data) {
    return SharedSettings._(
      authorID: data['authorID'],
      settingsData: PlannerSettingsData.fromData(data['settingsData']),
      lastRefreshed: data['lastRefreshed'] != null
          ? dateTimeFromTimestamp(data['lastRefreshed'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'settingsData': settingsData?.toJson(),
      'lastRefreshed': timestampFromDateTime(lastRefreshed),
    };
  }
}
