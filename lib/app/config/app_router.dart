import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/main/main_page.dart';
import 'package:grimity/presentation/splash/splash_page.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static GoRouter router(WidgetRef ref) =>
      GoRouter(navigatorKey: rootNavigatorKey, initialLocation: MainRoute.path, routes: $appRoutes);
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
