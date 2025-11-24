import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final pubspecFile = File("pubspec.yaml");
  final pubspecText = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecText);
  final version = pubspec['version'];

  stdout.write(version);
}
