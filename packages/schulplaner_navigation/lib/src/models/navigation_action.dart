import 'package:flutter/widgets.dart';
import 'package:schulplaner_navigation/src/models/navigation_item.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class NavigationActionItem {
  final int id;
  final IconData iconData;
  final TranslatableString name;
  final NavigationItem navigationItem;
  final Widget Function(BuildContext context) builder;

  const NavigationActionItem({
    required this.id,
    required this.iconData,
    required this.name,
    required this.builder,
    required this.navigationItem,
  });
}
