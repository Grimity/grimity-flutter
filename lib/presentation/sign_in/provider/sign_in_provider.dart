import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  @override
  void build() {}

  /// 로그인 결과에 따른 라우팅
  void _route(WidgetRef ref) {
    if (ref.read(userAuthProvider) != null) {
      HomeRoute().go(ref.context);
    } else {
      SignUpRoute().push(ref.context);
    }
  }

  /// 로그인
  Future<void> login(WidgetRef ref, LoginProvider provider) async {
    try {
      await ref.read(userAuthProvider.notifier).login(provider);
      _route(ref);
    } catch (e) {
      ToastService.showError('소셜 로그인에 실패했어요.', showImmediately: true);
    }
  }
}
