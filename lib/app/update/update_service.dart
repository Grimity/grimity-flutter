import 'package:url_launcher/url_launcher.dart';

abstract class UpdateService {
  Future<void> forceUpdate();
}

class UpdateServiceAndroid implements UpdateService {
  @override
  Future<void> forceUpdate() async {
    final url = 'market://details?id=com.grimity.flutter';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class UpdateServiceIOS implements UpdateService {
  @override
  Future<void> forceUpdate() async {
    final url = 'https://apps.apple.com/app/id6754501709';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
