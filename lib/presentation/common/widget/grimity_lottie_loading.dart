import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class GrimityLottieLoadingWidget extends StatelessWidget {
  final double size;

  const GrimityLottieLoadingWidget({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // 배경 투명 처리
      child: Center(child: Lottie.asset(Assets.lottie.loading, width: size, height: size, fit: BoxFit.contain)),
    );
  }
}
