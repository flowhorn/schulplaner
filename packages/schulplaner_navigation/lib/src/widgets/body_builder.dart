//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';

class BodyBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationBloc = NavigationBloc.of(context);
    return StreamBuilder<NavigationState>(
      stream: navigationBloc.currentMainPage,
      initialData: navigationBloc.currentMainPageValue,
      builder: (context, snapshot) {
        final navigationState = snapshot.data;
        return Builder(builder: (context) {
          if (navigationState.showSubChild) {
            return navigationState.subChild ??
                Container(
                  child: Text('Not found!'),
                );
          } else {
            if (navigationState.child != null) {
              return navigationState.child;
            } else {
              if (navigationState.index == 4) {
                return navigationBloc.router.libraryBuilder(context);
              } else {
                return navigationBloc.router.overviewBuilder(context);
              }
            }
          }
        });
      },
    );
  }
}
