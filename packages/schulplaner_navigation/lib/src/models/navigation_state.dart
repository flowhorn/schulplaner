import 'package:flutter/widgets.dart';
import 'navigation_item.dart';

class NavigationState {
  NavigationItem navigationItem;
  NavigationItem? subChildNavigationItem;
  int index;
  bool showSubChild;
  String? subChildTag;
  Widget? child;
  Widget? subChild;
  String? subChildName;
  List<Widget> Function(BuildContext context)? actions;
  NavigationState({
    this.index = 0,
    this.showSubChild = false,
    this.subChild,
    this.subChildName,
    this.subChildTag,
    this.child,
    this.actions,
    required this.navigationItem,
    this.subChildNavigationItem,
  });

  NavigationState copy() {
    return NavigationState(
      index: index,
      showSubChild: showSubChild,
      subChild: subChild,
      subChildName: subChildName,
      child: child,
      actions: actions,
      navigationItem: navigationItem,
      subChildNavigationItem: subChildNavigationItem,
    );
  }

  bool isSelected(NavigationItem other) {
    if (other == null) return false;
    if (showSubChild) {
      return other == subChildNavigationItem;
    }
    return other == navigationItem;
  }
}
