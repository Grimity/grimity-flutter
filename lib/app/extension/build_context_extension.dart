import 'dart:math';

import 'package:flutter/widgets.dart';

extension BuildContextExtension on BuildContext {
  static const int kGridMaxItemWidth = 260;
  static const int kGridMinItemCount = 2;

  /// SDK에서 렌더링하는 크기, 즉 디바이스의 고유 크기를 반환합니다.
  Size get deviceSize => MediaQuery.of(this).size;

  /// 가로상으로 표시해야 할 피드에 대한 아이템의 최대 개수를 반환합니다.
  int get feedRowCount {
    return max(
      kGridMinItemCount,
      deviceSize.width ~/ kGridMaxItemWidth,
    );
  }

  /// 가로상으로 표시해야 할 사용자 피드에 대한 아이템의 최대 개수를 반환합니다.
  int get userRowCount {
    return (feedRowCount / 2).toInt();
  }

  /// 가로상으로 표시해야 할 이미지 카드에 대한 아이템의 최대 개수를 반환합니다.
  int get photoRowCount {
    return feedRowCount + 1;
  }
}
