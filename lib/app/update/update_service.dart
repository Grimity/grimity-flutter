import 'package:url_launcher/url_launcher.dart';

abstract class UpdateService {
  Future<void> forceUpdate();
}

class UpdateServiceAndroid implements UpdateService {
  static const String androidPackageName = 'com.grimity.flutter';

  @override
  Future<void> forceUpdate() async {
    final url = 'market://details?id=$androidPackageName';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class UpdateServiceIOS implements UpdateService {
  static const String iosAppId = '6754501709';

  @override
  Future<void> forceUpdate() async {
    final url = 'https://apps.apple.com/app/id$iosAppId';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
