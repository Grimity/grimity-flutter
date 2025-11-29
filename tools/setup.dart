import 'dart:io';

import 'src/run.dart';

/// 그리미티 플러터 프로젝트에서 앱 서명 키가 정의된 레파지토리의 경로.
const kFastlaneRepository = "git@github.com/Grimity/grimity-flutter-certs.git";

/// Fastlane이 설치되어 있는지 확인하고 없다면 brew를 통해 Fastlane을 설치합니다
Future<void> ensureFastlaneInstalled() async {
  final result = await Process.run("brew", ["list", "fastlane"]);
  if (result.exitCode == 0) return;

  run("brew", ["install", "fastlane"]);
}

/// Fastlane match 명령을 실행하며 주어진 타입의 프로비저닝 프로필을 동기화합니다.
Future<void> runFastlaneMatch(String profile) async {
  await run("fastlane", ["match", profile, "--readonly", "--git_url", kFastlaneRepository]);
}

void main() async {
  // Mac 환경은 앱 서명 키를 공유하기 위해서 Fastlane을 사용하도록 함.
  if (Platform.isMacOS) {
    await ensureFastlaneInstalled();
    await runFastlaneMatch("development");
    await runFastlaneMatch("appstore");
    await runFastlaneMatch("adhoc");
  }

  await run("dart", ["run", "git_config", "fetch"]);
  await run("dart", ["run", "build_runner", "build", "--delete-conflicting-outputs"]);
}
