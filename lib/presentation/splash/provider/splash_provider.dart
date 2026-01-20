import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/linking/pending_deep_link_provider.dart';
import 'package:grimity/app/update/version.dart';
import 'package:grimity/domain/usecase/system_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/provider/user_subscribe_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class Splash extends _$Splash {
  @override
  void build() {}

  // 앱 업데이트 필요 여부 반환.
  Future<bool> checkUserAndRoute(WidgetRef ref) async {
    // 앱 업데이트 필요 여부.
    final needUpdate = await checkNeedUpdate();
    final pendingLink = ref.read(pendingDeepLinkProvider.notifier).consume();

    // 유저 정보 조회 시도
    // 조회 실패 시 로그인 화면으로 이동
    await ref.read(userAuthProvider.notifier).getUser();
    if (ref.read(userAuthProvider) == null) {
      if (!ref.context.mounted) return false;

      SignInRoute().push(ref.context);
      return needUpdate;
    }

    // 유저 정보 조회 성공 시 메인 화면으로 이동
    if (!ref.context.mounted) return false;

    // 유저 정보 로그인 시도 후 구독 여부 조회
    ref.read(userSubscribeProvider.notifier).getSubscription();
    HomeRoute().go(ref.context);

    /// [ColdStart] 딥링크 처리
    if (pendingLink != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(routerProvider).push(pendingLink),
      );
    }

    return needUpdate;
  }

  Future<bool> checkNeedUpdate() async {
    // 개발 환경은 앱 업데이트 필요 여부 false
    if (Flavor.isDev) return false;

    final result = await getAppVersionUseCase.execute();
    final packageInfo = await PackageInfo.fromPlatform();
    if (result.isFailure) return false;

    final serverVersion = Version.parse(result.data.version);
    final currentVersion = Version.parse(packageInfo.version);

    return currentVersion.isNeedForceUpdate(serverVersion);
  }
}
