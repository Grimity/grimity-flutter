import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

/// 공통 PullToRefresh 인디케이터
class GrimityRefreshIndicator extends StatelessWidget {
  const GrimityRefreshIndicator({super.key, required this.child, required this.onRefresh});

  final Widget child;
  final Future<void> Function() onRefresh;

  Future<void> _runRefresh() async {
    // 최소 로딩 시간
    final minDuration = Duration(milliseconds: 900);

    try {
      await Future.wait([onRefresh(), Future.delayed(minDuration)]);
    } catch (_) {
      ToastService.showError('새로고침 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: _runRefresh,
      offsetToArmed: 60.0,
      builder: (context, child, controller) {
        const height = 60.0;
        final val = controller.value.clamp(0.0, 1.0);
        final step = (val * 10).floor().clamp(0, 9);
        final state = controller.state;

        final indicator = switch (state) {
          IndicatorState.dragging ||
          IndicatorState.armed => Assets.icons.refresh.values[step].svg(width: 24, height: 24),
          IndicatorState.loading => Lottie.asset(Assets.lottie.refresh, width: 24, height: 24),
          _ => const SizedBox.shrink(),
        };

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(height: height, child: indicator),
            Transform.translate(offset: Offset(0, height * val), child: child),
          ],
        );
      },
      child: child,
    );
  }
}
