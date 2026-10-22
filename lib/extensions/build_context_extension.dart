import 'package:flutter/widgets.dart';
import 'package:flutter_nested_scroll/flutter_nested_scroll.dart';
import 'package:pervice/pervice.dart';

/// [BuildContext]에 대한 유틸리티 확장.
extension BuildContextExtension on BuildContext {
  /// 위젯의 생명주기에 맞춰 자동으로 해제하는 중첩 스크롤 컨트롤러를 반환합니다.
  NestedScrollController useNestedScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
    ScrollControllerCallback? onAttach,
    ScrollControllerCallback? onDetach,
  }) {
    final state = stateOf(
      () => NestedScrollController(
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: keepScrollOffset,
        debugLabel: debugLabel,
        onAttach: onAttach,
        onDetach: onDetach,
      ),
      onDispose: (e) => e.dispose(),
    );

    return state.value;
  }
}
