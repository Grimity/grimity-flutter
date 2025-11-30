import 'package:flutter/material.dart';

extension ImageExtension on num {
  // 캐시 사이즈
  int cacheSize(BuildContext context) {
    assert(!isInfinite, "이미지 캐시 크기는 유한해야 합니다.");
    assert(!isNegative, "이미지 캐시 크기는 음수가 될 수 없습니다.");

    // 위젯 사이즈 x 디바이스 픽셀 비율
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
