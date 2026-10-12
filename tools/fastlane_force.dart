import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'src/fastlane.dart';

Future<void> main() async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('Fastlane 서명 인증서 동기화는 macOS에서만 지원합니다.');
  }

  final env = DotEnv()..load(['.env']);

  await Fastlane.ensureInstalled();
  await Fastlane.force('development', 'com.grimity.flutter', env);
  await Fastlane.force('appstore', 'com.grimity.flutter', env);
  await Fastlane.force('adhoc', 'com.grimity.flutter', env);
}
