import 'package:flutter/widgets.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';

typedef AppRoute<T> = Future<T> Function(BuildContext context);

class NavigationRouter {
  final AppRoute openAppSettings;
  final AppRoute openMyProfilePage;
  final AppRoute openPlannersSheet;

  final WidgetBuilder overviewBuilder;
  final WidgetBuilder libraryBuilder;

  NavigationRouter({
    required this.openAppSettings,
    required this.openMyProfilePage,
    required this.openPlannersSheet,
    required this.overviewBuilder,
    required this.libraryBuilder,
  });

  static NavigationRouter of(BuildContext context) {
    return NavigationBloc.of(context).router;
  }
}
