import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class GrimityTransition extends StatelessWidget {
  const GrimityTransition({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: Duration(milliseconds: 250),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}