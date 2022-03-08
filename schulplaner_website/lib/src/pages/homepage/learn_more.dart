import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/parts/layout_title.dart';
import 'package:schulplaner_website/src/routes.dart';

class LearnMoreSection extends StatelessWidget {
  const LearnMoreSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LayoutTitle(
          text: 'Erfahre mehr...',
        ),
        SizedBox(height: 16),
        _LearnMoreDonate(),
        _LearnMoreOpenSource(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class _LearnMoreDonate extends StatelessWidget {
  const _LearnMoreDonate();
  @override
  Widget build(BuildContext context) {
    return _LearnMoreElement(
      iconData: Icons.favorite_outline,
      title: 'wie du Schulplaner unterstützen kannst',
      onTap: () {
        openNavigationPage(context, NavigationItem.donate);
      },
    );
  }
}

class _LearnMoreOpenSource extends StatelessWidget {
  const _LearnMoreOpenSource();
  @override
  Widget build(BuildContext context) {
    return _LearnMoreElement(
      iconData: Icons.code_outlined,
      title: 'dass Schulplaner Open-Source ist',
      onTap: () {
        openNavigationPage(context, NavigationItem.opensource);
      },
    );
  }
}

class _LearnMoreElement extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;

  const _LearnMoreElement({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              iconData,
              color: Colors.white,
            ),
            radius: 48,
          ),
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
