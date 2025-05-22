import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class Splash extends _$Splash {
  @override
  void build() {}

  // TODO: 앱 버전 체크 로직 추가
  Future<void> checkAppVersion() async {
    return;
  }

  Future<void> checkUserAndRoute(WidgetRef ref) async {
    // 토큰이 없는 경우
    // 첫 로그인 / 로그아웃 상태로 간주, 로그인 화면으로 이동
    final token = await loadTokenUseCase.execute();
    if (token == null) {
      if (!ref.context.mounted) return;

      SignInRoute().push(ref.context);
      return;
    }

    // 토큰이 있는 경우 유저 정보 조회 시도
    // 유저 정보 조회 실패 시 로그인 화면으로 이동
    await ref.read(userAuthProvider.notifier).getUser();
    if (ref.read(userAuthProvider) == null) {
      if (!ref.context.mounted) return;

      SignInRoute().push(ref.context);
      return;
    }

    // 유저 정보 조회 성공 시 메인 화면으로 이동
    if (!ref.context.mounted) return;
    MainRoute().go(ref.context);
  }
}
