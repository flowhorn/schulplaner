import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_navigation/src/widgets/drawer_collapsion_state.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class SchulplanerDrawer extends StatelessWidget {
  final Widget libraryTabletWidget;

  const SchulplanerDrawer({
    Key key,
    required this.libraryTabletWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    return StreamBuilder<bool>(
      stream: drawerBloc.isCollapsed,
      initialData: drawerBloc.isCollapsedValue,
      builder: (context, snapshot) {
        final isCollapsed = snapshot.data;
        final child = Container(
          width: isCollapsed ? 80 : 290,
          child: Drawer(
            elevation: 0,
            child: Material(
              color: getDrawerBackgroundColor(context),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AppBar(
                      title: Text(
                        isCollapsed ? '' : "Schulplaner",
                        style: TextStyle(color: getPrimaryColor(context)),
                      ),
                      backgroundColor: getDrawerBackgroundColor(context),
                      elevation: 0.0,
                    ),
                    Expanded(
                      child: _DrawerContent(
                        libraryTabletWidget: libraryTabletWidget,
                      ),
                    ),
                    FormDivider(),
                    DrawerCollapsionState(),
                  ],
                ),
              ),
            ),
          ),
        );
        return AnimatedSwitcher(
          key: ValueKey('AnimatedSwitcherDrawer'),
          child: child,
          duration: Duration(milliseconds: 250),
        );
      },
    );
  }
}

class _DrawerContent extends StatelessWidget {
  final Widget libraryTabletWidget;

  const _DrawerContent({Key key, this.libraryTabletWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          DrawerTile(
            name: getString(context).home,
            icon: Icons.home,
            onTap: () {
              NavigationBloc.of(context).setMainPageWithIndex(context, 0);
            },
            navigationItem: NavigationItem.home,
          ),
          buildDrawerTile(
            context,
            1,
          ),
          buildDrawerTile(
            context,
            2,
          ),
          buildDrawerTile(
            context,
            3,
          ),
          FormDivider(),
          libraryTabletWidget,
        ],
      ),
    );
  }

  DrawerTile buildDrawerTile(BuildContext context, int index) {
    final navigationBloc = NavigationBloc.of(context);
    final item = navigationBloc.getNavigationActionItem(index);
    return DrawerTile(
      icon: item?.iconData ?? Icons.navigation,
      name: item?.name?.getText(context) ?? '-',
      onTap: () {
        navigationBloc.setMainPageWithIndex(context, index);
      },
      navigationItem: item.navigationItem,
    );
  }
}
