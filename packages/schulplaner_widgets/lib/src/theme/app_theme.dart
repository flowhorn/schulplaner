import 'package:flutter/material.dart';
import 'design.dart';

Brightness getBrightness(BuildContext context) => Theme.of(context).brightness;
ThemeData newAppTheme(BuildContext context,
    {Color? primaryColor, Color? accentColor, Color? backgroundColor}) {
  ThemeData parentTheme = Theme.of(context);

  final newAccentColor = accentColor ?? parentTheme.accentColor;
  return ThemeData(
    brightness: parentTheme.brightness,
    primaryColor: primaryColor ?? parentTheme.primaryColor,
    accentColor: newAccentColor,
    backgroundColor: backgroundColor ?? getBackgroundColor(context),
    scaffoldBackgroundColor: backgroundColor ?? getBackgroundColor(context),
  );
}

ThemeData newAppThemeDesign(BuildContext context, Design? design) {
  ThemeData parentTheme = Theme.of(context);

  final newAccentColor = design?.accent ?? parentTheme.accentColor;
  return ThemeData(
    brightness: parentTheme.brightness,
    primaryColor: design?.primary ?? parentTheme.primaryColor,
    accentColor: newAccentColor,
    backgroundColor: getBackgroundColor(context),
    scaffoldBackgroundColor: getBackgroundColor(context),
    buttonTheme: ButtonThemeData(
      buttonColor: newAccentColor,
      highlightColor: newAccentColor,
    ),
  );
}

Color getPrimaryColor(BuildContext context) => Theme.of(context).primaryColor;
Color getAccentColor(BuildContext context) => Theme.of(context).accentColor;

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
