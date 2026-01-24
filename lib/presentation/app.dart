import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/linking/initialize_app_provider.dart';
import 'package:grimity/app/linking/pending_deep_link_provider.dart';
import 'package:grimity/app/static/push_notification.dart';
import 'package:grimity/app/util/pointer_event_filter.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void runFlavoredApp() async {
  await Flavor.instance.setup();

  // iPadOS 26.1+ 가짜 터치 이벤트 필터링
  PointerEventFilter.install();

  // Initialize talker
  final talker = TalkerFlutter.init();

  // 포그라운드 푸시 알림 구현을 위해 관련 플러그인 초기화.
  await PushNotification.initializePlugin();

  // 앱 진입 시에 알림 또는 배지 초기화.
  await PushNotification.clearAll();

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(talker: talker, settings: TalkerRiverpodLoggerSettings(printStateFullData: false)),
      ],
      child: App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  /// 해당 빌더는 라우트마다 공통으로 적용되는 위젯 래퍼를 구성합니다.
  static Widget routerBuilder(BuildContext context, Widget? child) {
    return GestureDetector(
      // 빈 화면에 클릭하면 현재 포커스가 정상적으로 취소되도록 이를 보장합니다.
      onTap: () => FocusScope.of(context).unfocus(),
      child: FToastBuilder()(context, child),
    );
  }

  /// 새로운 포그라운드 메세지가 도착한 경우 호출됩니다.
  Future<void> onForegroundMessage() async {
    await ref.read(userAuthProvider.notifier).getUser();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PushNotification.addListener(onForegroundMessage);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PushNotification.removeListener(onForegroundMessage);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 백그라운드로 가거나 종료될 때 배지와 알림 초기화.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      PushNotification.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // [WarmStart] 딥링크 이벤트 처리
    ref.listen(pendingDeepLinkProvider, (previous, next) {
      // initializeApp 플래그를 통해 [ColdStart] 처리는 여기서 하지 않음
      final initializeApp = ref.read(initializeAppProvider);

      if (next != null && initializeApp == true) {
        final link = ref.read(pendingDeepLinkProvider.notifier).consume();
        if (link != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(routerProvider).push(link);
          });
        }
      }
    });

    return MaterialApp.router(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.appTheme,
      builder: routerBuilder,
    );
  }
}
