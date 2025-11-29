import 'dart:io';

/// 주어진 실행 파일과 인자를 이용하여 프로세스를 실행하고,
/// stdout과 stderr를 실시간으로 콘솔에 출력합니다.
Future<void> run(String executable, List<String> arguments, {Map<String, String>? environment}) async {
  final process = await Process.start(
    executable,
    arguments,
    runInShell: true,
    environment: environment,
  );

  // stdout 실시간 출력
  process.stdout.transform(SystemEncoding().decoder).listen((data) {
    stdout.write(data);
  });

  // stderr 실시간 출력
  process.stderr.transform(SystemEncoding().decoder).listen((data) {
    stderr.write(data);
  });
}
