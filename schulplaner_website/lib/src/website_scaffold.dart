import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:design_utils/design_utils.dart';
import 'package:schulplaner_website/src/blocs/website_bloc.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';

import 'parts/desktop.dart';
import 'parts/mobile.dart';

class WebsiteScaffold extends StatelessWidget {
  final NavigationItem navigationItem;
  final Widget body;

  const WebsiteScaffold({Key key, this.navigationItem, this.body})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: WebsiteBloc(navigationItem),
      child: ResponsiveUI(
        mobileBuilder: (context) => MobileScaffold(
          body: body,
        ),
        desktopBuilder: (context) => DesktopScaffold(
          body: body,
        ),
      ),
    );
  }
}
