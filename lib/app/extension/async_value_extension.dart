import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/grimity_transition.dart';

extension AsyncValueFadeExtension<T> on AsyncValue<T> {
  /// 페이드 전환 애니메이션 적용.
  Widget fadeWhen({
    required Widget Function(T data) data,
    required Widget Function(Object error, StackTrace stackTrace) error,
    required Widget Function() loading,
  }) {
    return GrimityTransition.fade(
      value: this,
      child: when(
        data: data,
        error: error,
        loading: loading,
      ),
    );
  }
}
