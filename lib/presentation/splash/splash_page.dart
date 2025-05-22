import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/presentation/splash/provider/splash_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:grimity/gen/assets.gen.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(splashProvider.notifier).checkUserAndRoute(ref);
      return null;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: [const Color(0xFFC5F1C8), Colors.white, const Color(0xFFA2E88A), const Color(0xFFCCFF90)],
              options: AnimatedMeshGradientOptions(speed: 5, grain: 0.1),
              seed: 25,
            ),
          ),
          Positioned.fill(
            child: Align(alignment: Alignment.center, child: Assets.images.logo.svg(width: 190.w, height: 54.h)),
          ),
        ],
      ),
    );
  }
}
