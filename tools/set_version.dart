import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml_magic/yaml_magic.dart';

void main(List<String> args) {
  final parser =
      ArgParser()..addOption(
        "version",
        abbr: "v",
        help: "Version to set",
        valueHelp: "1.2.3-123",
        mandatory: true,
      );

  final argResults = parser.parse(args);
  final newVersion = argResults["version"];

  final pubspecFile = File("pubspec.yaml");
  final pubspecEdit = YamlMagic.load(pubspecFile.path);

  pubspecEdit["version"] = newVersion;
  pubspecFile.writeAsStringSync(pubspecEdit.toString());
}
