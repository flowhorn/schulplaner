import 'package:flutter/material.dart';
import 'src/website_scaffold.dart';

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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WebsiteScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
