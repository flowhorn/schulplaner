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
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: homepageWebsite,
      routes: {
        homepageWebsiteRoute: (context) => homepageWebsite,
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
