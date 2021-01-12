import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

Future<void> openUrl({String urlString, bool openInNewWindow = true}) async {
  await launch(urlString);
}

void downloadFile(String url, String name) {
  html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  anchorElement.download = name;
  anchorElement.click();
}
