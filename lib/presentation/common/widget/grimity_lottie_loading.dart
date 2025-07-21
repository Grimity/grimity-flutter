import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class GrimityLottieLoadingWidget extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final bool center;

  const GrimityLottieLoadingWidget({super.key, this.size = 90, this.backgroundColor, this.center = true});

  @override
  Widget build(BuildContext context) {
    Widget child = Lottie.asset(Assets.lottie.loading, width: size, height: size, fit: BoxFit.contain);
    if (backgroundColor != null) {
      child = Container(color: backgroundColor, child: child);
    }
    if (center) {
      child = Center(child: child);
    }
    return child;
  }
}
