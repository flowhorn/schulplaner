import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/routes.dart';

import 'src/widgets/web_transition.dart';

void main() {
  //setPathUrlStrategy();
  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schulplaner',
      theme: ThemeData(
        colorScheme: getColorScheme(
          primary: Colors.white,
          secondary: Colors.teal,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: NoTransitionsOnWeb(),
      ),
      darkTheme: ThemeData(
        colorScheme: getColorScheme(
          primary: Colors.grey[850]!,
          secondary: Colors.teal,
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: NoTransitionsOnWeb(),
      ),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      initialRoute: homepageWebsiteRoute,
      routes: navigationRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
