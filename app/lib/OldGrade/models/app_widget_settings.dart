class AppWidgetSettings {
  final bool darkmode;

  const AppWidgetSettings({
    required this.darkmode,
  });

  factory AppWidgetSettings.fromData(dynamic data) {
    return AppWidgetSettings(
      darkmode: data['darkmode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkmode': darkmode,
    };
  }

  AppWidgetSettings copyWith({
    bool? darkmode,
  }) {
    return AppWidgetSettings(
      darkmode: darkmode ?? this.darkmode,
    );
  }
}
