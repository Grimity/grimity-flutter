import 'run.dart';

Future<void> runFvm(String executable, {Map<String, String>? environment}) {
  return run("dart", ["pub", "global", "run", "fvm:main", ...executable.split(" ")], environment: environment);
}
