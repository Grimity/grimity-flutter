import 'package:flutter/material.dart';
import 'package:gds/gds.dart';

class SignInView extends StatelessWidget {
  const SignInView({
    super.key,
    required this.signInMediaWallView,
    required this.signInBodyView,
    required this.signInGradient,
  });

  final Widget signInMediaWallView;
  final Widget signInBodyView;
  final Widget signInGradient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          signInMediaWallView,
          signInGradient,
          SafeArea(
            child: GdsToastHost(child: signInBodyView),
          ),
        ],
      ),
    );
  }
}
