import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_navigation/src/logic/navigation_router.dart';
import 'package:schulplaner_navigation/src/models/navigation_item.dart';
import '../models/navigation_state.dart';

class NavigationBloc extends BlocBase {
  final navigatorKey = GlobalKey<NavigatorState>();
  final NavigationRouter router;
  final NavigationActionItem Function(int index) getNavigationActionItem;
  final _currentPageSubject = BehaviorSubject<NavigationState>.seeded(
    NavigationState(
      index: 0,
      navigationItem: NavigationItem.home,
    ),
  );

  NavigationBloc({
    required this.router,
    required this.getNavigationActionItem,
  });

  Stream<NavigationState> get currentMainPage => _currentPageSubject;

  NavigationState get currentMainPageValue => _currentPageSubject.value;

  Function(NavigationState) get setMainPage => _currentPageSubject.add;

  void openSubChild(
    String tag,
    Widget subChild,
    String title, {
    WidgetListBuilder? actions,
    required NavigationItem navigationItem,
  }) {
    final newData = currentMainPageValue.copy();
    newData.showSubChild = true;
    newData.subChildTag = tag;
    newData.subChild = SlideUp(
      child: subChild,
      key: Key('Test'),
    );
    newData.subChildName = title;
    newData.actions = actions;
    newData.subChildNavigationItem = navigationItem;
    _currentPageSubject.add(newData);
  }

  void goBack() {
    final newData = currentMainPageValue.copy();
    newData.showSubChild = false;
    newData.subChild = null;
    newData.subChildName = null;
    newData.subChildNavigationItem = null;
    newData.subChildTag = null;
    newData.actions = null;
    _currentPageSubject.add(newData);
  }

  void setMainPageWithIndex(
    BuildContext context,
    int index,
  ) {
    final newdata = currentMainPageValue.copy();
    newdata.index = index;
    newdata.showSubChild = false;
    newdata.subChildName = null;
    newdata.subChild = null;
    newdata.subChildTag = null;
    newdata.subChildNavigationItem = null;
    newdata.actions = null;
    if (index == 0) {
      newdata.navigationItem = NavigationItem.home;
    } else if (index == 4) {
      newdata.navigationItem = NavigationItem.library;
    } else {
      newdata.navigationItem = getNavigationActionItem(index).navigationItem;
    }
    switch (index) {
      case 0:
        newdata.child = router.overviewBuilder(context);
        break;
      case 1:
        newdata.child = getNavigationActionItem(1).builder(context);
        break;
      case 2:
        newdata.child = getNavigationActionItem(2).builder(context);
        break;
      case 3:
        newdata.child = getNavigationActionItem(3).builder(context);
        break;
      case 4:
        newdata.child = router.libraryBuilder(context);
        break;
    }
    setMainPage(newdata);
  }

  Future<T?> openSubPage<T>({required WidgetBuilder builder, String? tag}) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: builder,
        settings: RouteSettings(name: tag),
      ),
    );
  }

  static NavigationBloc of(BuildContext context) {
    return BlocProvider.of<NavigationBloc>(context);
  }

  @override
  void dispose() {
    _currentPageSubject.close();
  }
}
