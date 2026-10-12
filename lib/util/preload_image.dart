import 'dart:async';

import 'package:flutter/widgets.dart';

/// 이미지를 미리 로드하고 첫 프레임이 준비될 때까지 기다립니다.
Future<void> preloadImage(ImageProvider provider) async {
  final completer = Completer<void>();
  final stream = provider.resolve(ImageConfiguration.empty);
  final listener = ImageStreamListener(
    (image, _) {
      image.dispose();
      if (!completer.isCompleted) completer.complete();
    },
    onError: (Object error, StackTrace? stackTrace) {
      if (!completer.isCompleted) completer.completeError(error, stackTrace);
    },
  );

  stream.addListener(listener);

  try {
    await completer.future;
  } finally {
    stream.removeListener(listener);
  }
}
