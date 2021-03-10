// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void downloadFileImplementation(String url, String name) {
  final anchorElement = html.AnchorElement(href: url);
  anchorElement.download = name;
  anchorElement.click();
}