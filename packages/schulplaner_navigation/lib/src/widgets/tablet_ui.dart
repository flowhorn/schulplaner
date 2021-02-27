//@dart=2.11
import 'package:flutter/material.dart';
import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_navigation/src/logic/navigation_router.dart';
import 'package:schulplaner_navigation/src/widgets/body_builder.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';
import 'drawer.dart';

class TabletUI extends StatelessWidget {
  final WidgetBuilder plannerStateBuilder;
  final Widget libraryTabletWidget;
  const TabletUI({
    Key key,
    @required this.plannerStateBuilder,
    @required this.libraryTabletWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final navigationBloc = NavigationBloc.of(context);
    return Material(
      color: getBackgroundColor(context),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchulplanerDrawer(
              libraryTabletWidget: libraryTabletWidget,
            ),
            Expanded(
              child: Column(
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Builder(
                        builder: plannerStateBuilder,
                      ),
                    ),
                    actions: [
                      StreamBuilder<NavigationState>(
                          stream: navigationBloc.currentMainPage,
                          initialData: navigationBloc.currentMainPageValue,
                          builder: (context, snapshot) {
                            final navigationState = snapshot.data;
                            return Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.settings),
                                    onPressed: () {
                                      NavigationRouter.of(context)
                                          .openAppSettings(context);
                                    }),
                                if (navigationState.actions != null)
                                  ...navigationState.actions(context),
                              ],
                            );
                          }),
                    ],
                  ),
                  Expanded(
                    child: BodyBuilder(),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
