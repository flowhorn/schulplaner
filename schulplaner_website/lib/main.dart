import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:schulplaner_website/src/routes.dart';

void main() {
  runApp(MyApp());
}

final _model = ThemeModel();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ThemeModel>(
      create: (_) => _model..init(),
      child: Consumer<ThemeModel>(
        builder: (context, model, child) {
          return MaterialApp(
            title: 'Schulplaner',
            theme: ThemeData(
              primaryColor: model.darkMode ? Colors.grey[850] : Colors.white,
              accentColor: Colors.teal,
              brightness: model.darkMode ? Brightness.dark : Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(),
            ),
            initialRoute: homepageWebsiteRoute,
            routes: navigationRoutes,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
