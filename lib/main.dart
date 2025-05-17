import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize get_it
  await configureDependenciesProd();

  // Initialize talker
  final talker = TalkerFlutter.init();

  // Initialize Kakao
  KakaoSdk.init(nativeAppKey: '9ef16b15112d4c1ad60660adc4c39a93');

  runApp(ProviderScope(observers: [TalkerRiverpodObserver(talker: talker)], child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router(ref),
          theme: AppTheme.appTheme,
          builder: (context, child) => child!,
        );
      },
    );
  }
}
