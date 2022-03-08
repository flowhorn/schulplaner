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

const homepageWebsiteRoute = '/';
const aboutWebsiteRoute = '/about';
const donateWebsiteRoute = '/donate';
const downloadWebsiteRoute = '/download';
const impressumWebsiteRoute = '/impressum';
const privacyWebsiteRoute = '/privacy';
const opensourceWebsiteRoute = '/opensource';

const homepageWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.homepage,
  body: HomePage(),
);

const aboutWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.about,
  body: AboutPage(),
);
const donateWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.donate,
  body: DonatePage(),
);
const downloadWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.download,
  body: DownloadPage(),
);
const impressumWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.impressum,
  body: ImpressumPage(),
);
const privacyWebsite = WebsiteScaffold(
  navigationItem: NavigationItem.privacy,
  body: PrivacyPage(),
);

const opensourceWebsite = WebsiteScaffold(
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
