import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/exception/login_canceled_exception.dart';
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
      final router = widgetRef.read(routerProvider);

      // login 시도
      await ref.read(userAuthProvider.notifier).login(provider);

      // 로그인 이후 구독 정보 수신
      ref.read(userSubscribeProvider.notifier).getSubscription();

      // 로그인 결과에 따른 라우팅 처리
      _route(router);
    } catch (e, s) {
      // 사용자에 의한 로그인 취소 시 에러 처리 제외.
      if (e is LoginCanceledException) {
        return;
      }

      ToastService.showFailure('소셜 로그인에 실패했어요.');
      FirebaseCrashlytics.instance.recordError(e, s, reason: '소셜 로그인 오류');
    }
  }
}
