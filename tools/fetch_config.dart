// ignore_for_file: avoid_print

import 'dart:io';

const red = "\x1B[31m";
const green = "\x1B[32m";
const reset = "\x1B[0m";

void log(String str, {String color = ""}) {
  print("$color$str$reset");
}

Future<void> main() async {
  log("Fetching private config...");

  // 임시 폴더와 프로젝트 최상위 폴더.
  final tempDir = Directory("temp");
  final rootDir = Directory("./");

  try {
    // 깃허브 레파지토리 파일 불러오기.
    final cloneResult = await Process.run("git", [
      "clone",
      "https://github.com/Grimity/grimity-flutter-config",
      "temp",
    ]);

    // 파일 불러오기에 실패한 경우.
    if (cloneResult.exitCode != 0) {
      log("Git clone failed: ${cloneResult.stderr}", color: red);
      await tempDir.delete(recursive: true);
      exit(1);
    }

    // 불러온 파일을 프로젝트 폴더에 복사 붙여넣기.
    await for (final entity in tempDir.list(recursive: true)) {
      if (entity is File) {
        // 깃허브 파일은 제외.
        if (entity.path.contains(".git")) {
          continue;
        }

        final relativePath = entity.path.replaceFirst("${tempDir.path}${Platform.pathSeparator}", "");
        final newFile = File("${rootDir.path}${Platform.pathSeparator}$relativePath")..createSync(recursive: true);
        await entity.copy(newFile.path);
      }
    }

    log("Config files copied into ${rootDir.absolute}", color: green);
  } finally {
    // 임시 폴더 제거.
    await tempDir.delete(recursive: true);
  }
}
