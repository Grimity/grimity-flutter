import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  @override
  void build() {}

  void _route(WidgetRef ref) {
    if (ref.read(userAuthProvider) != null) {
      MainRoute().go(ref.context);
    } else {
      // TODO: 회원가입 화면 라우팅
    }
  }

  Future<void> login(WidgetRef ref, LoginProvider provider) async {
    try {
      await ref.read(userAuthProvider.notifier).login(provider);
      _route(ref);
    } catch (e) {
      // TODO: 로그인 실패 알림
    }
  }
}
