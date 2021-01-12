import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schulplaner',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(),
      ),
      initialRoute: homepageWebsiteRoute,
      routes: navigationRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
