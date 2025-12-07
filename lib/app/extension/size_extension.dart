import 'package:flutter/widgets.dart';

extension SizeExtension on Size {
  /// 해당 크기의 가로/세로 비율을 계산하고 이를 반환합니다.
  double get aspectRatio {
    assert(width > 0 && height > 0);
    return width / height;
  }
}
