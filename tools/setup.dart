import 'dart:io';

import 'src/run.dart';

void main() async {
  await run('dart', ['run', 'git_config', 'fetch']);

  // Mac 환경은 앱 서명 키를 공유하기 위해서 Fastlane을 사용하도록 함.
  if (Platform.isMacOS) {
    await run('dart', ['run', 'tools/fastlane_fetch.dart']);
  }
}
