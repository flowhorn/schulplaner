import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

import 'configuration_data.dart';

class AppSettingsData {
  final bool darkmode, autodark, coloredAppBar;
  final Color primary, accent;
  final String languagecode;
  final ConfigurationData configurationData;
  final GradeSpan? gradespan;
  final AppWidgetSettings appwidgetsettings;

  const AppSettingsData._({
    required this.darkmode,
    required this.autodark,
    required this.coloredAppBar,
    required this.primary,
    required this.accent,
    required this.languagecode,
    required this.configurationData,
    required this.gradespan,
    required this.appwidgetsettings,
  });

  factory AppSettingsData.fromString(String? data) {
    Map<String, dynamic> map = data == null ? {} : jsonDecode(data);
    return AppSettingsData._(
        darkmode: map['darkmode'] ?? false,
        autodark: map['autodark'] ?? false,
        coloredAppBar: map['coloredAppBar'] ?? true,
        primary: map['primary'] != null ? fromHex(map['primary']) : Colors.teal,
        accent:
            map['accent'] != null ? fromHex(map['accent']) : Colors.pinkAccent,
        languagecode: map['languagecode'],
        configurationData: ConfigurationData.fromData(map['config']),
        gradespan: map['gradespan'] == null
            ? null
            : GradeSpan.fromData(
                map['gradespan']?.cast<String, dynamic>() ?? {}),
        appwidgetsettings:
            AppWidgetSettings.fromData(map['appwidgetsettings'] ?? {}));
  }

  String toJsonString() {
    return jsonEncode({
      'darkmode': darkmode,
      'autodark': autodark,
      'coloredAppBar': coloredAppBar,
      'languagecode': languagecode,
      'primary': getHex(primary),
      'accent': getHex(accent),
      'config': configurationData.toJson(),
      'gradespan': gradespan?.toJson(),
      'appwidgetsettings': appwidgetsettings.toJson(),
    });
  }

  AppSettingsData copyWith({
    bool? darkmode,
    bool? autodark,
    bool? coloredAppBar,
    Color? primary,
    Color? accent,
    String? languagecode,
    ConfigurationData? configurationData,
    GradeSpan? gradespan,
    AppWidgetSettings? appwidgetsettings,
  }) {
    return AppSettingsData._(
      darkmode: darkmode ?? this.darkmode,
      autodark: autodark ?? this.autodark,
      coloredAppBar: coloredAppBar ?? this.coloredAppBar,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      languagecode: languagecode ?? this.languagecode,
      configurationData: configurationData ?? this.configurationData.copyWith(),
      gradespan: gradespan ?? this.gradespan,
      appwidgetsettings: appwidgetsettings ?? this.appwidgetsettings,
    );
  }

  ThemeData getThemeData() {
    final newbrightness = darkmode == true
        ? Brightness.dark
        : (autodark ? autoBrightness() : Brightness.light);
    return ThemeData(
      primaryColor: coloredAppBar
          ? primary
          : (newbrightness == Brightness.light
              ? Colors.white
              : Colors.grey[900]),
      accentColor: accent,
      brightness: newbrightness,
      bottomSheetTheme: bottomSheetTheme,
      dialogTheme: dialogTheme,
      backgroundColor: getBackgroundColorByBrightness(newbrightness),
      scaffoldBackgroundColor: getBackgroundColorByBrightness(newbrightness),
      buttonTheme: ButtonThemeData(
        buttonColor: accent,
        highlightColor: accent,
      ),
    );
  }

  bool validate() {
    return true;
  }
}
