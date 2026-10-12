import 'dart:io';

/// 주어진 실행 파일과 인자를 이용하여 프로세스를 실행하고,
/// stdout과 stderr를 실시간으로 출력하며 종료될 때까지 기다립니다.
Future<void> run(String executable, List<String> arguments, {Map<String, String>? environment}) async {
  final process = await Process.start(
    executable,
    arguments,
    runInShell: true,
    environment: environment,
  );

  // stdout과 stderr를 모두 출력한 뒤 프로세스 종료 확인.
  await Future.wait([
    process.stdout.transform(SystemEncoding().decoder).forEach(stdout.write),
    process.stderr.transform(SystemEncoding().decoder).forEach(stderr.write),
  ]);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw ProcessException(executable, arguments, '명령어 실행에 실패했습니다.', exitCode);
  }
}
