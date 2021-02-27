import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/website_scaffold.dart';

import 'pages/about/about.dart';
import 'pages/donate/donate.dart';
import 'pages/download/download.dart';
import 'pages/homepage/homepage.dart';
import 'pages/impressum/impressum.dart';
import 'pages/opensource/opensource.dart';
import 'pages/privacy/privacy.dart';

final Map<String, WidgetBuilder> navigationRoutes = {
  homepageWebsiteRoute: (context) => homepageWebsite,
  aboutWebsiteRoute: (context) => aboutWebsite,
  donateWebsiteRoute: (context) => donateWebsite,
  downloadWebsiteRoute: (context) => downloadWebsite,
  impressumWebsiteRoute: (context) => impressumWebsite,
  privacyWebsiteRoute: (context) => privacyWebsite,
  opensourceWebsiteRoute: (context) => opensourceWebsite,
};

final homepageWebsiteRoute = '/';
final aboutWebsiteRoute = '/about';
final donateWebsiteRoute = '/donate';
final downloadWebsiteRoute = '/download';
final impressumWebsiteRoute = '/impressum';
final privacyWebsiteRoute = '/privacy';
final opensourceWebsiteRoute = '/opensource';

final homepageWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.homepage,
  body: HomePage(),
);

final aboutWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.about,
  body: AboutPage(),
);
final donateWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.donate,
  body: DonatePage(),
);
final downloadWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.download,
  body: DownloadPage(),
);
final impressumWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.impressum,
  body: ImpressumPage(),
);
final privacyWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.privacy,
  body: PrivacyPage(),
);

final opensourceWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.opensource,
  body: OpenSourcePage(),
);

Future<void> openNavigationPage(
    BuildContext context, NavigationItem navigationItem) {
  switch (navigationItem) {
    case NavigationItem.homepage:
      return _openHomepage(context);
    case NavigationItem.about:
      return _openAboutPage(context);
    case NavigationItem.donate:
      return _openDonatePage(context);
    case NavigationItem.download:
      return _openDownloadPage(context);
    case NavigationItem.impressum:
      return _openImpressumPage(context);
    case NavigationItem.privacy:
      return _openPrivacyPage(context);
    case NavigationItem.opensource:
      return _openOpenSourcePage(context);
  }
}

Future<void> _openHomepage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, homepageWebsiteRoute);
}

Future<void> _openDonatePage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, donateWebsiteRoute);
}

Future<void> _openImpressumPage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, impressumWebsiteRoute);
}

Future<void> _openPrivacyPage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, privacyWebsiteRoute);
}

Future<void> _openAboutPage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, aboutWebsiteRoute);
}

Future<void> _openDownloadPage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, downloadWebsiteRoute);
}

Future<void> _openOpenSourcePage(BuildContext context) async {
  await Navigator.pushReplacementNamed(context, opensourceWebsiteRoute);
}
