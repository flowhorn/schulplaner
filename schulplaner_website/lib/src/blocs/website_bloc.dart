import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';

class WebsiteBloc extends BlocBase {
  final NavigationItem navigationItem;

  const WebsiteBloc(this.navigationItem);

  @override
  void dispose() {}

  static WebsiteBloc of(BuildContext context) {
    return BlocProvider.of<WebsiteBloc>(context);
  }
}
