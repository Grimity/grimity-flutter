import 'package:flutter/material.dart';

import 'package:grimity/app/config/app_color.dart';

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
      backgroundColor: AppColor.primary4,
      body: Stack(children: [signInMediaWallView, signInGradient, signInBodyView]),
    );
  }
}
