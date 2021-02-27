//@dart=2.11
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';

class DrawerCollapsionState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    return Center(
      child: StreamBuilder<bool>(
        stream: drawerBloc.isCollapsed,
        initialData: drawerBloc.isCollapsedValue,
        builder: (context, snapshot) {
          final isCollapsed = snapshot.data;
          final child = isCollapsed
              ? Icon(Icons.chevron_right)
              : Icon(Icons.chevron_left);
          return AnimatedSwitcher(
            key: ValueKey('DrawerCollapsionState'),
            child: IconButton(
              icon: child,
              onPressed: () {
                drawerBloc.setCollapsed(!isCollapsed);
              },
            ),
            duration: Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                child: child,
                turns: animation,
              );
            },
          );
        },
      ),
    );
  }
}
