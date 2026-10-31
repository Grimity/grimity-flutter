// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'src/fastlane.dart';

Future<void> main() async {
  if (!Platform.isMacOS) {
    throw UnsupportedError('Fastlane 서명 인증서 가져오기는 macOS에서만 지원합니다.');
  }

  final env = DotEnv()..load(['.env']);

  await Fastlane.ensureInstalled();
  await Fastlane.readOnly("development", "com.grimity.flutter", env);
  await Fastlane.readOnly("appstore", "com.grimity.flutter", env);
  await Fastlane.readOnly("adhoc", "com.grimity.flutter", env);
}
