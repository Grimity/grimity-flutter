import 'package:flutter/widgets.dart';

/// [PageController]에 대한 유틸리티 확장.
extension PageControllerExtension on PageController {
  /// 현재 표시 중인 페이지의 인덱스.
  int get index {
    return hasClients ? (page?.round() ?? initialPage) : 0;
  }
}
