import 'dart:io';

/// 주어진 실행 파일과 인자를 이용하여 프로세스를 실행하고,
/// 터미널 입출력을 상속하여 로그인 등의 대화형 입력을 지원하고 종료될 때까지 기다립니다.
Future<void> run(String executable, List<String> arguments, {Map<String, String>? environment}) async {
  final process = await Process.start(
    executable,
    arguments,
    runInShell: true,
    environment: environment,
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw ProcessException(executable, arguments, '명령어 실행에 실패했습니다.', exitCode);
  }
}
