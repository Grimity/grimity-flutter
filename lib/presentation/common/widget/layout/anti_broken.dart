import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 해당 위젯은 자식 위젯의 레이아웃 결과가 일시적으로 0 사이즈로 깨지는 경우를 방어합니다.
///
/// 정상적인 레이아웃 결과가 있을 때의 사이즈를 캐싱해 두었다가
/// child의 width 또는 height가 0으로 계산되면
/// 이전에 캐싱된 사이즈를 그대로 사용합니다.
class AntiSizedBroken extends SingleChildRenderObjectWidget {
  const AntiSizedBroken({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _AntiSizedBrokenRenderBox();
  }
}

class _AntiSizedBrokenRenderBox extends RenderProxyBox {
  Size? _cachedSize;

  @override
  void performLayout() {
    assert(child != null);

    child!.layout(constraints, parentUsesSize: true);

    // 레이아웃 결과가 0 으로 깨진 경우.
    if (child!.size.isEmpty) {
      size = _cachedSize ?? child!.size;
    } else {
      size = child!.size;
      _cachedSize = size;
    }
  }
}
