import 'src/run.dart';

void main() async {
  await run('dart', ['run', 'pervice_openapi']);
  await run('dart', ['format', '.']);
}
