import 'package:flutter/gestures.dart';

/// iPadOS 26.1+ 버그 임시 해결책
/// https://github.com/flutter/flutter/issues/175606
/// https://github.com/flutter/flutter/issues/177992
///
/// 상태바 터치 시 (0, 0) 좌표에 가짜 터치 이벤트가 발생하여
/// Popup, Drawer 등이 자동으로 닫히는 문제를 해결합니다.
class PointerEventFilter {
  static bool _installed = false;

  /// 앱 시작 시 호출하여 (0, 0) 좌표 터치 이벤트를 필터링합니다.
  /// WidgetsFlutterBinding.ensureInitialized() 이후에 호출해야 합니다.
  static void install() {
    if (_installed) return;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_filterZeroOffsetEvent);
    _installed = true;
  }

  static void _filterZeroOffsetEvent(PointerEvent event) {
    if (event.position == Offset.zero) {
      GestureBinding.instance.cancelPointer(event.pointer);
    }
  }
}
