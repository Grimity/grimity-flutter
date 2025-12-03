import 'package:flutter/material.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/static/push_notification.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void runFlavoredApp() async {
  await Flavor.instance.setup();

  // Initialize talker
  final talker = TalkerFlutter.init();

  // 포그라운드 푸시 알림 구현을 위해 관련 플러그인 초기화.
  await PushNotification.initializePlugin();

  // 항상 사용자가 앱을 실행한 경우 알림 배지를 초기화합니다.
  FlutterAppBadge.count(0);

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(talker: talker, settings: TalkerRiverpodLoggerSettings(printStateFullData: false)),
      ],
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  /// 해당 빌더는 라우트마다 공통으로 적용되는 위젯 래퍼를 구성합니다.
  static Widget routerBuilder(BuildContext context, Widget? child) {
    return GestureDetector(
      // 빈 화면에 클릭하면 현재 포커스가 정상적으로 취소되도록 이를 보장합니다.
      onTap: () => FocusScope.of(context).unfocus(),
      child: FToastBuilder()(context, child),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      routerConfig: AppRouter.router(ref),
      theme: AppTheme.appTheme,
      builder: routerBuilder,
    );
  }
}
