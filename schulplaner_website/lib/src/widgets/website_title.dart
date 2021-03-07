import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';

class WebsiteTitle extends StatelessWidget {
  const WebsiteTitle();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text('Schulplaner'),
      onTap: () {
        openNavigationPage(context, NavigationItem.homepage);
      },
    );
  }
}
