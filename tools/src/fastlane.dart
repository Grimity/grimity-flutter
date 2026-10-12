import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'run.dart';

abstract class Fastlane {
  /// 앱 서명 키가 정의된 레파지토리의 경로.
  static const repository = 'https://github.com/Grimity/grimity-flutter-certs.git';

  /// Homebrew로 Fastlane을 설치하거나 기존 설치를 업데이트합니다.
  static Future<void> ensureInstalled() async {
    final result = await Process.run('brew', ['list', 'fastlane']);

    // 이미 설치되어 있다면 버전 업데이트 시도.
    if (result.exitCode == 0) {
      await run('brew', ['upgrade', 'fastlane']);
    } else {
      await run('brew', ['install', 'fastlane']);
    }
  }

  /// Fastlane match 명령을 실행하며 주어진 타입의 프로비저닝 프로필을 동기화합니다.
  static Future<void> readOnly(String profile, String appId, DotEnv env) async {
    await run(
      'fastlane',
      [
        'match',
        profile,
        '--readonly',
        '--git_url',
        repository,
        '--app_identifier',
        appId,
      ],
      environment: {
        'MATCH_PASSWORD': env['MATCH_PASSWORD']!,
      },
    );
  }

  /// 서명 인증서를 동기화하고 프로비저닝 프로파일을 강제로 갱신하여 저장소에 반영합니다.
  static Future<void> force(String profile, String appId, DotEnv env) async {
    await run(
      'fastlane',
      [
        'match',
        profile,
        '--force',
        '--git_url',
        repository,
        '--app_identifier',
        appId,
      ],
      environment: {
        'MATCH_PASSWORD': env['MATCH_PASSWORD']!,
      },
    );
  }
}
