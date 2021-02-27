import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_navigation/src/models/navigation_item.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;
  final NavigationItem navigationItem;
  const DrawerTile({
    required this.icon,
    required this.name,
    required this.onTap,
    required this.navigationItem,
  });
  @override
  Widget build(BuildContext context) {
    final navigationBloc = NavigationBloc.of(context);
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    return StreamBuilder<bool>(
      stream: drawerBloc.isCollapsed,
      initialData: drawerBloc.isCollapsedValue,
      builder: (context, snapshot) {
        final isCollapsed = snapshot.data;
        return StreamBuilder<NavigationState>(
          key: ValueKey(this.navigationItem),
          stream: navigationBloc.currentMainPage,
          initialData: navigationBloc.currentMainPageValue,
          builder: (context, snapshot) {
            final navigationState = snapshot.data;
            final isSelected = navigationState!.isSelected(navigationItem);

            final child = isSelected
                ? _Selected(
                    title: name,
                    iconData: icon,
                    isCollapsed: isCollapsed!,
                  )
                : _Unselected(
                    isCollapsed: isCollapsed!,
                    iconData: icon,
                    onTap: onTap,
                    title: name,
                  );
            return AnimatedSwitcher(
              key: ValueKey(this.navigationItem),
              child: child,
              duration: Duration(milliseconds: 250),
            );
          },
        );
      },
    );
  }
}

class _Selected extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool isCollapsed;

  const _Selected({
    Key? key,
    required this.iconData,
    required this.title,
    required this.isCollapsed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: getDrawerTileCardColor(context),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: isCollapsed
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: IconButton(
                icon: Icon(
                  iconData,
                  color: getPrimaryColor(context),
                ),
                onPressed: null,
              ),
            )
          : ListTile(
              leading: Icon(
                iconData,
                color: getPrimaryColor(context),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: getPrimaryColor(context),
                ),
              ),
            ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        topLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
        topRight: Radius.circular(8),
      )),
    );
  }
}

class _Unselected extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final bool isCollapsed;

  const _Unselected({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.isCollapsed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: isCollapsed
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: IconButton(
                icon: Icon(
                  iconData,
                  color: Theme.of(context).disabledColor,
                ),
                onPressed: onTap,
                tooltip: title,
              ),
            )
          : ListTile(
              leading: Icon(
                iconData,
                color: null,
              ),
              title: Text(title),
              onTap: onTap,
            ),
    );
  }
}
