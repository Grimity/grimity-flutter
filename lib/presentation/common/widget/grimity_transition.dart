import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class GrimityTransition {
  GrimityTransition._();

  static final switchDuration = Duration(milliseconds: 250);
  static final switchInCurve = Curves.ease;
  static final switchOutCurve = Curves.ease.flipped;

  /// 해당 위젯은 축 기반 전환 애니메이션을 구현합니다.
  static Widget axis({
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.vertical,
    required dynamic value,
    required Widget child,
  }) {
    return PageTransitionSwitcher(
      duration: switchDuration,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          fillColor: Colors.transparent,
          transitionType: transitionType,
          child: child,
        );
      },
      child: KeyedSubtree(key: ValueKey(value), child: child),
    );
  }

  /// 해당 위젯은 페이드 전환 애니메이션을 구현합니다.
  static Widget fade({
    required dynamic value,
    required Widget child,
  }) {
    return AnimatedSwitcher(
      duration: switchDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: KeyedSubtree(key: ValueKey(value), child: child),
    );
  }
}
