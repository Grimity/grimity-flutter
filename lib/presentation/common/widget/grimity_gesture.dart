import 'package:flutter/material.dart';

/// 해당 앱에서 사용되는 공통적인 제스처 감지 위젯을 구현합니다.
class GrimityGesture extends StatelessWidget {
  const GrimityGesture({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.child,
  });

  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Widget? child;

  static const hitTestBehavior = HitTestBehavior.opaque;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: GrimityGesture.hitTestBehavior,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
