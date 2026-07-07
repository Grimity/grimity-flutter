import 'package:flutter/material.dart';

class SignInGradient extends StatelessWidget {
  const SignInGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.maxFinite,
          height: 812,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.0), // rgba(0, 0, 0, 0.00)
                Colors.black.withValues(alpha: 0.8), // rgba(0, 0, 0, 0.80)
                Colors.black.withValues(alpha: 0.8), // rgba(0, 0, 0, 0.80)
              ],
              stops: [
                0.0, // 0%
                0.55, // 55%
                1.0, // 100%
              ],
            ),
          ),
        ),
      ),
    );
  }
}
