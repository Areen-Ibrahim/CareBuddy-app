import 'package:url_launcher/url_launcher.dart';

class UrlLauncherServices{
  static void openUrl(Uri url) async => await launchUrl(url);
}