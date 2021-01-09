import 'package:bloc/bloc_base.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';

class WebsiteBloc extends BlocBase {
  final NavigationItem navigationItem;

  WebsiteBloc(this.navigationItem);

  @override
  void dispose() {}
}
