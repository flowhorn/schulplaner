import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/routes.dart';

import 'src/widgets/web_transition.dart';

void main() {
  //setPathUrlStrategy();
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schulplaner',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: NoTransitionsOnWeb(),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.grey[850],
        accentColor: Colors.teal,
        brightness: Brightness.dark,
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
