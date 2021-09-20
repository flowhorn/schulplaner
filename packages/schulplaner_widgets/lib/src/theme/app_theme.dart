import 'package:flutter/material.dart';
import 'design.dart';

Brightness getBrightness(BuildContext context) => Theme.of(context).brightness;
ThemeData newAppTheme(BuildContext context,
    {Color? primaryColor, Color? secondaryColor, Color? backgroundColor}) {
  ThemeData parentTheme = Theme.of(context);

  final newAccentColor = secondaryColor ?? parentTheme.colorScheme.secondary;
  return ThemeData(
    brightness: parentTheme.brightness,
    colorScheme: getColorScheme(
      primary: primaryColor ?? parentTheme.primaryColor,
      secondary: newAccentColor,
      brightness: parentTheme.brightness,
    ),
    backgroundColor: backgroundColor ?? getBackgroundColor(context),
    scaffoldBackgroundColor: backgroundColor ?? getBackgroundColor(context),
  );
}

ColorScheme getColorScheme(
    {required Color primary,
    Color? secondary,
    required Brightness brightness}) {
  return ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(
      primary.value,
      {
        50: primary.withOpacity(.1),
        100: primary.withOpacity(.2),
        200: primary.withOpacity(.3),
        300: primary.withOpacity(.4),
        400: primary.withOpacity(.5),
        500: primary.withOpacity(.6),
        600: primary.withOpacity(.7),
        700: primary.withOpacity(.8),
        800: primary.withOpacity(.9),
        900: primary.withOpacity(1),
      },
    ),
    accentColor: secondary,
    brightness: brightness,
  );
}

ThemeData newAppThemeDesign(BuildContext context, Design? design) {
  return newAppTheme(
    context,
    primaryColor: design?.primary,
    secondaryColor: design?.accent,
  );
}

Theme clearAppTheme({required BuildContext context, required Widget child}) {
  ThemeData parentTheme = Theme.of(context);

  final colorScheme = getColorScheme(
    primary: parentTheme.brightness == Brightness.light
        ? Colors.white
        : Colors.grey[900] ?? parentTheme.primaryColor,
    secondary: parentTheme.brightness == Brightness.light
        ? Colors.grey[900]
        : Colors.white,
    brightness: parentTheme.brightness,
  );
  return Theme(
    data: ThemeData(
      colorScheme: colorScheme,
      brightness: parentTheme.brightness,
    ),
    child: child,
  );
}

ThemeData clearAppThemeData({required BuildContext context}) {
  ThemeData parentTheme = Theme.of(context);

  final colorScheme = getColorScheme(
    primary: parentTheme.brightness == Brightness.light
        ? Colors.white
        : Colors.grey[900] ?? parentTheme.primaryColor,
    secondary: parentTheme.brightness == Brightness.light
        ? Colors.grey[900]
        : Colors.white,
    brightness: parentTheme.brightness,
  );
  return ThemeData(
    colorScheme: colorScheme,
    brightness: parentTheme.brightness,
    backgroundColor: getBackgroundColor(context),
    scaffoldBackgroundColor: getBackgroundColor(context),
  );
}

Color getPrimaryColor(BuildContext context) => Theme.of(context).primaryColor;
Color getAccentColor(BuildContext context) =>
    Theme.of(context).colorScheme.secondary;

Color getBackgroundColor(BuildContext context) {
  return getBackgroundColorByBrightness(Theme.of(context).brightness);
}

Color getBackgroundColorByBrightness(Brightness brightness) {
  return brightness == Brightness.light ? Colors.white : Colors.grey[900]!;
}

Color getDrawerBackgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Colors.grey[200]!
      : Colors.grey[800]!;
}

Color getDrawerTileCardColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Colors.white
      : Colors.grey[850]!;
}

Color getSheetColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Colors.white
      : Colors.grey[850]!;
}

Color getBottomAppBarColor(BuildContext context) {
  return Theme.of(context).bottomAppBarColor;
}

bool isDarkColor(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness > 0.4) {
    return true;
  } // It's a light color
  else {
    return false;
  }
}

bool isReallyDarkColor(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness > 0.8) {
    return true;
  } // It's a light color
  else {
    return false;
  }
}

bool isReallyReallyDarkColor(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness > 0.9) {
    return true;
  } // It's a light color
  else {
    return false;
  }
}

bool isNotReallyDarkColor(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness > 0.2) {
    return true;
  } // It's a light color
  else {
    return false;
  }
}

bool isNotNotReallyDarkColor(Color color) {
  double darkness =
      1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  if (darkness > 0.1) {
    return true;
  } // It's a light color
  else {
    return false;
  }
}

Color getTextColor(Color? color) {
  if (color == null ? true : isDarkColor(color)) {
    return Colors.white;
  } else {
    return Colors.grey[850]!;
  }
}

Color getTextColorLight(Color? color) {
  if (color == null ? true : isDarkColor(color)) {
    return Colors.grey[100]!;
  } else {
    return Colors.grey[700]!;
  }
}

Color getClearTextColor(BuildContext context) {
  if (getBrightness(context) == Brightness.dark) {
    return Colors.white;
  } else {
    return Colors.grey[850]!;
  }
}

Color getEventualBorder(BuildContext context, Color inside) {
  ThemeData themeData = Theme.of(context);
  if (themeData.brightness == Brightness.light) {
    if (isNotReallyDarkColor(inside)) {
      return inside;
    } else {
      return Colors.grey[850]!;
    }
  } else {
    if (isReallyDarkColor(inside)) {
      return Colors.white;
    } else {
      return inside;
    }
  }
}

Color getVeryEventualBorder(BuildContext context, Color inside) {
  ThemeData themeData = Theme.of(context);
  if (themeData.brightness == Brightness.light) {
    if (isNotNotReallyDarkColor(inside)) {
      return inside;
    } else {
      return Colors.grey[850]!;
    }
  } else {
    if (isReallyReallyDarkColor(inside)) {
      return Colors.white;
    } else {
      return inside;
    }
  }
}

Color getEventualTextColor(BuildContext context, Color inside) {
  ThemeData themeData = Theme.of(context);
  if (themeData.brightness == Brightness.light) {
    if (isNotNotReallyDarkColor(inside)) {
      return inside;
    } else {
      return Colors.grey[850]!;
    }
  } else {
    if (isReallyReallyDarkColor(inside)) {
      return Colors.white;
    } else {
      return inside;
    }
  }
}

Color getTextPrimary(BuildContext context) {
  ThemeData themeData = Theme.of(context);
  Color inside = getPrimaryColor(context);
  if (themeData.brightness == Brightness.light) {
    if (isNotNotReallyDarkColor(inside)) {
      return inside;
    } else {
      return Colors.grey[850]!;
    }
  } else {
    if (isReallyReallyDarkColor(inside)) {
      return Colors.white;
    } else {
      return inside;
    }
  }
}

Color getHighlightedColor(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.grey[800]!;
  } else {
    return Colors.white;
  }
}

Color getDividerColor(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.grey[600]!;
  } else {
    return Colors.grey[400]!;
  }
}
