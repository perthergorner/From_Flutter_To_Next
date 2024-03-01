import 'package:url_launcher/url_launcher.dart';

class Browser {
  static void openWebBrowser(String url) async {
    if (url.isEmpty) return;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch';
  }

}