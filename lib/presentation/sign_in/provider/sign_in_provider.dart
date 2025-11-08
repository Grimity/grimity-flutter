import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/provider/user_subscribe_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  @override
  void build() {}

  /// 로그인 결과에 따른 라우팅
  void _route(GoRouter router) {
    if (ref.read(userAuthProvider) != null) {
      router.go(HomeRoute.path);
    } else {
      router.push(SignUpRoute.path);
    }
  }

  /// 로그인
  Future<void> login(WidgetRef widgetRef, LoginProvider provider) async {
    try {
      // 비동기 통신 이후 widgetRef가 dispose 될 수 있어 라우터 참조
      final router = AppRouter.router(widgetRef);

      // login 시도
      await ref.read(userAuthProvider.notifier).login(provider);

      // 로그인 이후 구독 정보 수신
      ref.read(userSubscribeProvider.notifier).getSubscription();

      // 로그인 결과에 따른 라우팅 처리
      _route(router);
    } catch (e, s) {
      ToastService.showError('소셜 로그인에 실패했어요.', showImmediately: true);

      FirebaseCrashlytics.instance.recordError(e, s, reason: '소셜 로그인 오류');
    }
  }
}
