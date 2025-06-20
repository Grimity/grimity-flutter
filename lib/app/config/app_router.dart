import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/main/main_page.dart';
import 'package:grimity/presentation/profile_edit/profile_crop_image_page.dart';
import 'package:grimity/presentation/profile_edit/profile_edit_page.dart';
import 'package:grimity/presentation/sign_in/sign_in_page.dart';
import 'package:grimity/presentation/upload_image/upload_image_page.dart';
import 'package:grimity/presentation/sign_up/sign_up_page.dart';
import 'package:grimity/presentation/splash/splash_page.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final GoRouter _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashRoute.path,
    routes: $appRoutes,
    // FIX: 카카오톡 App 로그인 시의 Routing 관련 문제 수정
    // Ref: https://github.com/kakao/kakao_flutter_sdk/issues/200
    redirect: (context, state) {
      final uri = state.uri;

      if (uri.scheme.contains('kakao') && uri.authority == 'oauth') {
        return SignInRoute.path;
      }

      return null;
    },
  );

  static GoRouter router(WidgetRef ref) => _router;
}

@TypedGoRoute<ProfileEditRoute>(path: ProfileEditRoute.path, name: ProfileEditRoute.name)
class ProfileEditRoute extends GoRouteData {
  const ProfileEditRoute(this.$extra);

  static const String path = '/profile-edit';
  static const String name = 'profile-edit';

  final User $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfileEditPage(user: state.extra as User);
}

@TypedGoRoute<CropImageRoute>(path: CropImageRoute.path, name: CropImageRoute.name)
class CropImageRoute extends GoRouteData {
  const CropImageRoute();

  static const String path = '/crop-image';
  static const String name = 'crop-image';

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileCropImagePage();
}

@TypedGoRoute<SplashRoute>(path: SplashRoute.path, name: SplashRoute.name)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  static const String path = '/splash';
  static const String name = 'splash';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<MainRoute>(path: MainRoute.path, name: MainRoute.name)
class MainRoute extends GoRouteData {
  const MainRoute();

  static const String path = '/main';
  static const String name = 'main';

  @override
  Widget build(BuildContext context, GoRouterState state) => const MainPage();
}

@TypedGoRoute<SignInRoute>(path: SignInRoute.path, name: SignInRoute.name)
class SignInRoute extends GoRouteData {
  const SignInRoute();

  static const String path = '/sign-in';
  static const String name = 'sign-in';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SignInPage();
}

@TypedGoRoute<SignUpRoute>(path: SignUpRoute.path, name: SignUpRoute.name)
class SignUpRoute extends GoRouteData {
  const SignUpRoute();

  static const String path = '/sign-up';
  static const String name = 'sign-up';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SignUpPage();
}

@TypedGoRoute<UploadImageRoute>(path: UploadImageRoute.path, name: UploadImageRoute.name)
class UploadImageRoute extends GoRouteData {
  const UploadImageRoute();

  static const String path = '/upload-image';
  static const String name = 'upload-image';

  @override
  Widget build(BuildContext context, GoRouterState state) => const UploadImagePage();
}
