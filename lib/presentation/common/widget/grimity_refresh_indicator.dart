import 'package:flutter/material.dart';
import 'package:flutter_refresh_indicator/flutter_refresh_indicator.dart';
import 'package:grimity/app/service/toast_service.dart';

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
    return PullToRefresh(onRefresh: _runRefresh, child: child);
  }
}
