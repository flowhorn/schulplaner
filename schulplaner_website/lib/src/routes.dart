import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/website_scaffold.dart';

import 'pages/homepage.dart';

final donateWebsiteRoute = '/donate';

final homepageWebsiteRoute = '/';
final homepageWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.homepage,
  body: Homepage(),
);