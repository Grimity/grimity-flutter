import 'package:flutter/material.dart';

extension ImageExtension on num {
  // 캐시 사이즈
  int cacheSize(BuildContext context) {
    // 위젯 사이즈 x 디바이스 픽셀 비율
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
