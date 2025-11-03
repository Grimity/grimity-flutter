import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

/// Grimity 공통 로딩 인디케이터 위젯.
///
/// Skeletonizer로 처리하기 애매한 구간에서
/// 간단한 로딩 상태(Spinner 형태)를 표시할 때 사용합니다.
class GrimityLoadingIndicator extends StatelessWidget {
  const GrimityLoadingIndicator({
    super.key,
    this.useCenter = true,
    this.padding = const EdgeInsets.symmetric(vertical: 80),
  });

  final bool useCenter;
  final EdgeInsetsGeometry padding;

  // loadMore시 사용하는 로딩 위젯
  factory GrimityLoadingIndicator.loadMore() => GrimityLoadingIndicator(padding: EdgeInsets.symmetric(vertical: 24));

  @override
  Widget build(BuildContext context) {
    final indicator = Padding(padding: padding, child: Lottie.asset(Assets.lottie.refresh, width: 24, height: 24));

    return useCenter ? Center(child: indicator) : indicator;
  }
}
