import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/parts/layout_title.dart';
import 'package:schulplaner_website/src/routes.dart';

class LearnMoreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutTitle(
          text: 'Erfahre mehr...',
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            BigElement(
              iconData: Icons.favorite_outline,
              title: 'wie du Schulplaner unterstützen kannst',
              onTap: () {
                openNavigationPage(context, NavigationItem.donate);
              },
            ),
            BigElement(
              iconData: Icons.code_outlined,
              title: 'dass Schulplaner Open-Source ist',
              onTap: () {
                openNavigationPage(context, NavigationItem.opensource);
              },
            ),
          ],
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class BigElement extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;

  const BigElement({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: Center(
            child: Column(
              children: [
                Icon(
                  iconData,
                  size: 96,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          radius: 70,
        ),
      ),
    );
  }
}
