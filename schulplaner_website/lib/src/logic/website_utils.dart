import 'package:url_launcher/url_launcher.dart';


Future<void> openUrl({
  required String urlString,
  bool openInNewWindow = true,
}) async {
  await launch(urlString);
}

