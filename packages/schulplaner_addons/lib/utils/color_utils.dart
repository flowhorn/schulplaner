import 'package:flutter/material.dart';

class ColorUtils {
  final ThemeData theme;

  const ColorUtils._(this.theme);

  factory ColorUtils.of(BuildContext context) {
    return ColorUtils._(Theme.of(context));
  }

  static Color getTextColor(Color? background) {
    if (background == null ? true : isDarkColor(background)) {
      return Colors.white;
    } else {
      return Colors.grey[850]!;
    }
  }

  Color getDefaultTextColor() {
    return getTextColor(theme.backgroundColor);
  }

  Color getPrimaryColor() {
    return theme.primaryColor;
  }

  Color getAccentColor() {
    return theme.colorScheme.secondary;
  }

  Color getBackgroundColor() {
    return theme.backgroundColor;
  }

  Color getClearBorderColor(BuildContext context, Color color) {
    ThemeData themeData = Theme.of(context);
    if (themeData.brightness == Brightness.light) {
      if (isNotReallyDarkColor(color)) {
        return color;
      } else {
        return Colors.grey[850]!;
      }
    } else {
      if (isReallyDarkColor(color)) {
        return Colors.white;
      } else {
        return color;
      }
    }
  }

  Color getDividerColor() {
    if (theme.brightness == Brightness.light) {
      return Colors.grey[850]!;
    } else {
      return Colors.white;
    }
  }

  static bool isDarkColor(Color color) {
    double darkness = 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    if (darkness > 0.4) {
      return true;
    } else {
      return false;
    }
  }

  static bool isReallyDarkColor(Color color) {
    double darkness = 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    if (darkness > 0.8) {
      return true;
    } else {
      return false;
    }
  }

  static bool isNotReallyDarkColor(Color color) {
    double darkness = 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    if (darkness > 0.2) {
      return true;
    } else {
      return false;
    }
  }
}
