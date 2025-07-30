import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/feed_detail/feed_detail_page.dart';
import 'package:grimity/presentation/feed_upload/feed_upload_page.dart';
import 'package:grimity/presentation/follow/follow_page.dart';
import 'package:grimity/presentation/album_edit/album_edit_page.dart';
import 'package:grimity/presentation/home/home_page.dart';
import 'package:grimity/presentation/image/image_viewer_page.dart';
import 'package:grimity/presentation/main/main_app_shell.dart';
import 'package:grimity/presentation/photo_select/photo_select_page.dart';
import 'package:grimity/presentation/profile/profile_page.dart';
import 'package:grimity/presentation/profile_edit/profile_crop_image_page.dart';
import 'package:grimity/presentation/profile_edit/profile_edit_page.dart';
import 'package:grimity/presentation/sign_in/sign_in_page.dart';
import 'package:grimity/presentation/sign_up/sign_up_page.dart';
import 'package:grimity/presentation/splash/splash_page.dart';
import 'package:grimity/presentation/storage/storage_page.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

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

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: [TypedGoRoute<HomeRoute>(path: HomeRoute.path, name: HomeRoute.name)],
    ),
    TypedStatefulShellBranch<PaintBranchData>(
      routes: [TypedGoRoute<PaintRoute>(path: PaintRoute.path, name: PaintRoute.name)],
    ),
    TypedStatefulShellBranch<FollowingBranchData>(
      routes: [TypedGoRoute<FollowingRoute>(path: FollowingRoute.path, name: FollowingRoute.name)],
    ),
    TypedStatefulShellBranch<BoardBranchData>(
      routes: [TypedGoRoute<BoardRoute>(path: BoardRoute.path, name: BoardRoute.name)],
    ),
    TypedStatefulShellBranch<MyBranchData>(
      routes: [
        TypedGoRoute<MyRoute>(path: MyRoute.path, name: MyRoute.name),
        TypedGoRoute<ProfileRoute>(path: MyRoute.path + ProfileRoute.path, name: ProfileRoute.name),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return MainAppShell(navigationShell: navigationShell);
  }
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const String path = '/home';
  static const String name = 'home';

  @override
  Widget build(BuildContext context, GoRouterState state) => HomePage();
}

class PaintBranchData extends StatefulShellBranchData {
  const PaintBranchData();
}

class PaintRoute extends GoRouteData {
  const PaintRoute();

  static const String path = '/paint';
  static const String name = 'paint';

  @override
  Widget build(BuildContext context, GoRouterState state) => Center(child: Text('Paint'));
}

class FollowingBranchData extends StatefulShellBranchData {
  const FollowingBranchData();
}

class FollowingRoute extends GoRouteData {
  const FollowingRoute();

  static const String path = '/following';
  static const String name = 'following';

  @override
  Widget build(BuildContext context, GoRouterState state) => Center(child: Text('Following'));
}

class BoardBranchData extends StatefulShellBranchData {
  const BoardBranchData();
}

class BoardRoute extends GoRouteData {
  const BoardRoute();

  static const String path = '/board';
  static const String name = 'board';

  @override
  Widget build(BuildContext context, GoRouterState state) => Center(child: Text('Board'));
}

class MyBranchData extends StatefulShellBranchData {
  const MyBranchData();
}

class MyRoute extends GoRouteData {
  const MyRoute();

  static const String path = '/my';
  static const String name = 'my';

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfilePage(url: null);
}

class ProfileRoute extends GoRouteData {
  final String url;

  const ProfileRoute({required this.url});

  static const String path = '/profile/:url';
  static const String name = 'profile';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: ProfilePage(url: url),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), // 오른쪽에서 시작
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

@TypedGoRoute<ProfileEditRoute>(path: ProfileEditRoute.path, name: ProfileEditRoute.name)
class ProfileEditRoute extends GoRouteData {
  const ProfileEditRoute();

  static const String path = '/profile-edit';
  static const String name = 'profile-edit';

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfileEditPage();
}

@TypedGoRoute<CropImageRoute>(path: CropImageRoute.path, name: CropImageRoute.name)
class CropImageRoute extends GoRouteData {
  const CropImageRoute({required this.type});

  static const String path = '/crop-image';
  static const String name = 'crop-image';

  final UploadImageType type;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfileCropImagePage(type: type);
}

@TypedGoRoute<SplashRoute>(path: SplashRoute.path, name: SplashRoute.name)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  static const String path = '/splash';
  static const String name = 'splash';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
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

@TypedGoRoute<AlbumEditRoute>(path: AlbumEditRoute.path, name: AlbumEditRoute.name)
class AlbumEditRoute extends GoRouteData {
  const AlbumEditRoute();

  static const String path = '/album-edit';
  static const String name = 'album-edit';

  @override
  Widget build(BuildContext context, GoRouterState state) => const AlbumEditPage();
}

@TypedGoRoute<FollowRoute>(path: FollowRoute.path, name: FollowRoute.name)
class FollowRoute extends GoRouteData {
  const FollowRoute();

  static const String path = '/follow';
  static const String name = 'follow';

  @override
  Widget build(BuildContext context, GoRouterState state) => const FollowPage();
}

@TypedGoRoute<StorageRoute>(path: StorageRoute.path, name: StorageRoute.name)
class StorageRoute extends GoRouteData {
  const StorageRoute();

  static const String path = '/storage';
  static const String name = 'storage';

  @override
  Widget build(BuildContext context, GoRouterState state) => const StoragePage();
}

@TypedGoRoute<FeedUploadRoute>(path: FeedUploadRoute.path, name: FeedUploadRoute.name)
class FeedUploadRoute extends GoRouteData {
  const FeedUploadRoute({required this.from});

  static const String path = '/feed-upload';
  static const String name = 'feed-upload';

  final String from;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FeedUploadPage(from: from);
  }
}

@TypedGoRoute<PhotoSelectRoute>(path: PhotoSelectRoute.path, name: PhotoSelectRoute.name)
class PhotoSelectRoute extends GoRouteData {
  const PhotoSelectRoute();

  static const String path = '/photo-select';
  static const String name = 'photo-select';

  @override
  Widget build(BuildContext context, GoRouterState state) => const PhotoSelectPage();
}

@TypedGoRoute<FeedDetailRoute>(path: FeedDetailRoute.path, name: FeedDetailRoute.name)
class FeedDetailRoute extends GoRouteData {
  final String id;

  const FeedDetailRoute({required this.id});

  static const String path = '/feed/:id';
  static const String name = 'feed-detail';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FeedDetailPage(feedId: id);
  }
}

@TypedGoRoute<ImageViewerRoute>(path: ImageViewerRoute.path, name: ImageViewerRoute.name)
class ImageViewerRoute extends GoRouteData {
  final int initialIndex;
  final List<String> imageUrls;

  const ImageViewerRoute({required this.initialIndex, required this.imageUrls});

  static const String path = '/image-viewer';
  static const String name = 'image-viewer';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ImageViewerPage(imageUrls: imageUrls, initialIndex: initialIndex);
  }
}
