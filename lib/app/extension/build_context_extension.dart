import 'dart:math';

import 'package:flutter/widgets.dart';

extension BuildContextExtension on BuildContext {
  static const int kGridMaxItemWidth = 260;
  static const int kGridMinItemCount = 2;

  /// 가로상으로 표시해야 할 피드에 대한 아이템의 최대 개수를 반환합니다.
  int get feedRowCount {
    final deviceSize = MediaQuery.of(this).size;

    return max(
      kGridMinItemCount,
      deviceSize.width ~/ kGridMaxItemWidth,
    );
  }

  /// 가로상으로 표시해야 할 사용자 피드에 대한 아이템의 최대 개수를 반환합니다.
  int get authorFeedRowCount {
    return feedRowCount + 1;
  }
}
