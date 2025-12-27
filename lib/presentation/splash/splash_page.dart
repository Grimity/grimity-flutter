import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/app_update/show_app_update_dialog.dart';
import 'package:grimity/presentation/splash/provider/splash_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/gen/assets.gen.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(splashProvider.notifier).checkUserAndRoute(ref).then(
        (needUpdate) {
          if (needUpdate) {
            // 화면 이동 이후 UpdateDialog 표시.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final currentContext = rootNavigatorKey.currentContext;
              if (currentContext != null) {
                showAppUpdateDialog(currentContext);
              }
            });
          }
        },
      );
      return null;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0B0B0B), Color(0xFF09302A)],
                  stops: [0.0, 1.0],
                ),
                // noise texture image 추가
                image: DecorationImage(
                  image: AssetImage(Assets.images.noiseTexture.path),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Assets.icons.icon.logo.svg(
                width: 190,
                height: 54,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
