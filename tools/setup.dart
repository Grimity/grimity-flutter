import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'src/run_fvm.dart';
import 'src/run.dart';

/// 그리미티 플러터 프로젝트에서 앱 서명 키가 정의된 레파지토리의 경로.
const kFastlaneRepository = "https://github.com/Grimity/grimity-flutter-certs.git";

/// 그리미티 플러터 프로젝트의 환경 변수를 불러오고 관리합니다.
late final DotEnv dotenv;

/// Fastlane이 설치되어 있는지 확인하고 없다면 brew를 통해 Fastlane을 설치합니다
Future<void> ensureFastlaneInstalled() async {
  final result = await Process.run("brew", ["list", "fastlane"]);

  // 이미 설치되어 있다면 버전 업데이트 시도.
  if (result.exitCode == 0) {
    await run("brew", ["upgrade", "fastlane"]);
  } else {
    await run("brew", ["install", "fastlane"]);
  }
}

/// Fastlane match 명령을 실행하며 주어진 타입의 프로비저닝 프로필을 동기화합니다.
Future<void> runFastlaneMatch(String profile, String appId) async {
  await run(
    "fastlane",
    [
      "match",
      profile,
      "--readonly",
      "--git_url",
      kFastlaneRepository,
      "--app_identifier",
      appId,
    ],
    environment: {
      "MATCH_PASSWORD": dotenv["MATCH_PASSWORD"]!,
    },
  );
}

void main() async {
  dotenv = DotEnv()..load([".env"]);

  await run("dart", ["run", "git_config", "fetch"]);

  // FVM 설정
  await run("dart", ["pub", "global", "activate", "fvm"]);
  await runFvm("use --force");

  // Mac 환경은 앱 서명 키를 공유하기 위해서 Fastlane을 사용하도록 함.
  if (Platform.isMacOS) {
    await ensureFastlaneInstalled();
    await runFastlaneMatch("development", "com.grimity.flutter.dev"); // dev
    await runFastlaneMatch("appstore", "com.grimity.flutter"); // prod
    await runFastlaneMatch("adhoc", "com.grimity.flutter"); // prod
  }

  await runFvm("dart pub get");
  await runFvm("dart run build_runner build --delete-conflicting-outputs");
}
