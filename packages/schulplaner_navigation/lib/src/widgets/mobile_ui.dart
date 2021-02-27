//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_navigation/src/logic/navigation_router.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

import 'body_builder.dart';

class MobileUI extends StatelessWidget {
  final WidgetBuilder plannerStateBuilder;
  const MobileUI({
    Key key,
    @required this.plannerStateBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final navigationBloc = NavigationBloc.of(context);
    return StreamBuilder<NavigationState>(
      stream: navigationBloc.currentMainPage,
      initialData: navigationBloc.currentMainPageValue,
      builder: (context, snapshot) {
        final navigationState = snapshot.data;
        return Scaffold(
          appBar: _AppBar(
            navigationState: navigationState,
            plannerStateBuilder: plannerStateBuilder,
          ),
          body: BodyBuilder(),
          bottomNavigationBar: _BottomNavBar(
            navigationState: navigationState,
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final NavigationState navigationState;
  final WidgetBuilder plannerStateBuilder;
  const _AppBar({
    Key key,
    @required this.navigationState,
    @required this.plannerStateBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!navigationState.showSubChild) {
      return AppHeaderAdvanced(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                NavigationRouter.of(context).openAppSettings(context);
              })
        ],
        title: Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Builder(
            builder: plannerStateBuilder,
          ),
        ),
      );
    } else {
      return AppHeaderAdvanced(
        title: Text(navigationState.subChildName),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationBloc.of(context).goBack();
            }),
        actions: navigationState.actions != null
            ? navigationState.actions(context)
            : null,
      );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(57.0);
}

class _BottomNavBar extends StatelessWidget {
  final NavigationState navigationState;
  const _BottomNavBar({
    Key key,
    @required this.navigationState,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        int currentindex = navigationState.index ?? 0;
        return Container(
          child: BottomNavigationBar(
            backgroundColor: getDrawerBackgroundColor(context),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: getString(context).home),
              buildNavigationItem(context, 1),
              buildNavigationItem(context, 2),
              buildNavigationItem(context, 3),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder), label: getString(context).library),
            ],
            currentIndex: currentindex,
            fixedColor: getAccentColor(context),
            type: BottomNavigationBarType.fixed,
            onTap: (newindex) {
              NavigationBloc.of(context)
                  .setMainPageWithIndex(context, newindex);
            },
          ),
        );
      },
    );
  }

  BottomNavigationBarItem buildNavigationItem(BuildContext context, int index) {
    final item = NavigationBloc.of(context).getNavigationActionItem(index);
    return BottomNavigationBarItem(
      icon: Icon(item?.iconData ?? Icons.navigation),
      label: item?.name?.getText(context) ?? '-',
    );
  }
}
