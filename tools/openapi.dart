import 'src/run.dart';

void main() async {
  await run("dart", ["run", "swagger_parser"]);
  await run("dart", ["run", "build_runner", "build"]);
}
