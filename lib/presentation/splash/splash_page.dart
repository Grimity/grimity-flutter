import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/presentation/splash/provider/splash_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0B0B0B), Color(0xFF09302A)],
                  stops: [0.0, 1.0],
                ),
                // noise texture image 추가
                image: DecorationImage(
                  image: AssetImage('assets/images/noise_texture.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Assets.images.logo.svg(
                width: 190.w,
                height: 54.h,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
