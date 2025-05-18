import 'package:flutter/material.dart';
import 'package:grimity/presentation/sign_in/sign_in_view.dart';
import 'package:grimity/presentation/sign_in/view/sign_in_body_view.dart';
import 'package:grimity/presentation/sign_in/view/sign_in_media_wall_view.dart';
import 'package:grimity/presentation/sign_in/widget/sign_in_gradient.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInView(
      signInMediaWallView: const SignInMediaWallView(),
      signInBodyView: const SignInBodyView(),
      signInGradient: const SignInGradient(),
    );
  }
}
