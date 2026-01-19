import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/linking/external_link.dart';
import 'package:grimity/app/linking/external_link_parser.dart';
import 'package:grimity/app/linking/initialize_app_provider.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/album_organize/album_organize_page.dart';
import 'package:grimity/presentation/block/blocked_users_page.dart';
import 'package:grimity/presentation/board/tabs/board_page.dart';
import 'package:grimity/presentation/board/search/board_search_page.dart';
import 'package:grimity/presentation/chat_message/chat_message_page.dart';
import 'package:grimity/presentation/chat_new/new_chat_page.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/feed_detail/feed_detail_page.dart';
import 'package:grimity/presentation/feed_upload/feed_upload_page.dart';
import 'package:grimity/presentation/follow/follow_page.dart';
import 'package:grimity/presentation/album_edit/album_edit_page.dart';
import 'package:grimity/presentation/following_feed/following_feed_page.dart';
import 'package:grimity/presentation/home/home_page.dart';
import 'package:grimity/presentation/image/image_viewer_page.dart';
import 'package:grimity/presentation/main/main_app_shell.dart';
import 'package:grimity/presentation/chat/chat_page.dart';
import 'package:grimity/presentation/notification/notification_page.dart';
import 'package:grimity/presentation/photo_select/photo_select_page.dart';
import 'package:grimity/presentation/post_detail/post_detail_page.dart';
import 'package:grimity/presentation/post_upload/post_upload_page.dart';
import 'package:grimity/presentation/profile/profile_page.dart';
import 'package:grimity/presentation/profile_edit/profile_crop_image_page.dart';
import 'package:grimity/presentation/profile_edit/profile_edit_page.dart';
import 'package:grimity/presentation/ranking/ranking_page.dart';
import 'package:grimity/presentation/report/report_page.dart';
import 'package:grimity/presentation/search/search_page.dart';
import 'package:grimity/presentation/setting/setting_page.dart';
import 'package:grimity/presentation/sign_in/sign_in_page.dart';
import 'package:grimity/presentation/sign_up/sign_up_page.dart';
import 'package:grimity/presentation/splash/splash_page.dart';
import 'package:grimity/presentation/storage/storage_page.dart';
import 'package:grimity/app/linking/pending_deep_link_provider.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashRoute.path,
    routes: $appRoutes,
    observers: [AppRouter.observer],
    // FIX: 카카오톡 App 로그인 시의 Routing 관련 문제 수정
    // Ref: https://github.com/kakao/kakao_flutter_sdk/issues/200
    redirect: (context, state) {
      final uri = state.uri;

      if (uri.scheme.contains('kakao') && uri.authority == 'oauth') {
        return SignInRoute.path;
      }

      final isWebLink = uri.scheme == 'http' || uri.scheme == 'https';

      // 웹 링크(딥링크)인 경우 redirect 처리
      if (isWebLink) {
        final parsed = ExternalLinkParser.parse(uri.toString());
        final isLogin = ref.read(userAuthProvider) != null;
        final initializeApp = ref.read(initializeAppProvider);
        final pendingDeepLinkNotifier = ref.read(pendingDeepLinkProvider.notifier);

        /// [ColdStart]인 경우
        if (initializeApp == false) {
          // 유효하지 않은 경로는 딥링크 세팅 없이 스플래시 페이지 이동 처리
          if (parsed.type == ExternalLinkType.unknown) {
            return SplashRoute.path;
          }

          // 유효한 경로는 딥링크 세팅 후 스플래시 페이지 이동 처리
          Future.microtask(() => pendingDeepLinkNotifier.setLink(parsed.location));
          return SplashRoute.path;
        }
        /// [WarmStart]인 경우
        else {
          // 유효하지 않은 경로는 딥링크 세팅 없이 로그인 여부에 따라
          if (parsed.type == ExternalLinkType.unknown) {
            return isLogin ? HomeRoute.path : SignInRoute.path;
          }

          if (isLogin) {
            // 로그인 된 사용자의 경우 딥링크 세팅 후 홈 페이지로 이동
            pendingDeepLinkNotifier.setLink(parsed.location);
            return HomeRoute.path;
          } else {
            // 로그인되지 않은 사용자의 경우 딥링크 세팅 없이 회원가입 페이지로 이동
            return SignInRoute.path;
          }
        }
      }

      return null;
    },
  );
}

abstract final class AppRouter {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);

  // URL을 내부 라우팅으로 이동
  static void handleServerUrl(BuildContext context, String url, {String? myUrl}) {
    final parsed = ExternalLinkParser.parse(url);
    switch (parsed.type) {
      case ExternalLinkType.profile:
        context.push('/profile/${parsed.url!}');
        break;
      case ExternalLinkType.post:
        context.push('/posts/${parsed.id}');
        break;
      case ExternalLinkType.feed:
        context.push('/feeds/${parsed.id}');
        break;
      case ExternalLinkType.unknown:
        break;
    }
  }
}

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(
      routes: [TypedGoRoute<HomeRoute>(path: HomeRoute.path, name: HomeRoute.name)],
    ),
    TypedStatefulShellBranch<PaintBranchData>(
      routes: [TypedGoRoute<RankingRoute>(path: RankingRoute.path, name: RankingRoute.name)],
    ),
    TypedStatefulShellBranch<FollowingBranchData>(
      routes: [TypedGoRoute<FollowingRoute>(path: FollowingRoute.path, name: FollowingRoute.name)],
    ),
    TypedStatefulShellBranch<BoardBranchData>(
      routes: [TypedGoRoute<BoardRoute>(path: BoardRoute.path, name: BoardRoute.name)],
    ),
    TypedStatefulShellBranch<ChatBranchData>(
      routes: [
        TypedGoRoute<ChatRoute>(path: ChatRoute.path, name: ChatRoute.name),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainAppShell(navigationShell: navigationShell);
  }

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return SplashRoute.defaultBuildPage(context, state, builder(context, state, navigationShell));
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

class RankingRoute extends GoRouteData {
  const RankingRoute();

  static const String path = '/ranking';
  static const String name = 'ranking';

  @override
  Widget build(BuildContext context, GoRouterState state) => RankingPage();
}

class FollowingBranchData extends StatefulShellBranchData {
  const FollowingBranchData();
}

class FollowingRoute extends GoRouteData {
  const FollowingRoute();

  static const String path = '/following';
  static const String name = 'following';

  @override
  Widget build(BuildContext context, GoRouterState state) => FollowingFeedPage();
}

class BoardBranchData extends StatefulShellBranchData {
  const BoardBranchData();
}

class BoardRoute extends GoRouteData {
  const BoardRoute();

  static const String path = '/board';
  static const String name = 'board';

  @override
  Widget build(BuildContext context, GoRouterState state) => BoardPage();
}

@TypedGoRoute<BoardSearchRoute>(path: BoardSearchRoute.path, name: BoardSearchRoute.name)
class BoardSearchRoute extends GoRouteData {
  BoardSearchRoute();

  static const String path = '/boardSearch';
  static const String name = 'boardSearch';

  @override
  Widget build(BuildContext context, GoRouterState state) => BoardSearchPage();
}

class ChatBranchData extends StatefulShellBranchData {
  const ChatBranchData();
}

class ChatRoute extends GoRouteData {
  const ChatRoute();

  static const String path = '/chatMessage';
  static const String name = 'chatMessage';

  @override
  Widget build(BuildContext context, GoRouterState state) => ChatPage();
}

@TypedGoRoute<NewChatRoute>(path: NewChatRoute.path, name: NewChatRoute.name)
class NewChatRoute extends GoRouteData {
  const NewChatRoute();

  static const String path = '/newChat';
  static const String name = 'newChat';

  @override
  Widget build(BuildContext context, GoRouterState state) => NewChatPage();
}

@TypedGoRoute<ChatMessageRoute>(path: ChatMessageRoute.path, name: ChatMessageRoute.name)
class ChatMessageRoute extends GoRouteData {
  const ChatMessageRoute(this.id);

  final String id;

  static const String path = '/chats/:id';
  static const String name = 'chats';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatMessagePage(chatId: id);
  }
}

@TypedGoRoute<ProfileRoute>(path: ProfileRoute.path, name: ProfileRoute.name)
class ProfileRoute extends GoRouteData {
  final String url;

  const ProfileRoute({required this.url});

  static const String path = '/profile/:url';
  static const String name = 'userProfile';

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfilePage(url: url);
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

  /// 스프레시 관련 페이지에서 사용하는 전환 애니메이션 빌더.
  static get transitionsBuilder => (
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  };

  /// 스프레시 관련 페이지에서 사용되는 [buildPage] 함수의 공통 선언입니다.
  static Page<void> defaultBuildPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: transitionsBuilder,
    );
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return defaultBuildPage(context, state, build(context, state));
  }
}

@TypedGoRoute<SignInRoute>(path: SignInRoute.path, name: SignInRoute.name)
class SignInRoute extends GoRouteData {
  const SignInRoute();

  static const String path = '/sign-in';
  static const String name = 'sign-in';

  @override
  Widget build(BuildContext context, GoRouterState state) => const SignInPage();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return SplashRoute.defaultBuildPage(context, state, build(context, state));
  }
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
  const AlbumEditRoute(this.$extra);

  final List<Album> $extra;

  static const String path = '/album-edit';
  static const String name = 'album-edit';

  @override
  Widget build(BuildContext context, GoRouterState state) => AlbumEditPage(albums: $extra);
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
  const FeedUploadRoute();

  static const String path = '/feed-upload';
  static const String name = 'feed-upload';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final feed = state.extra as Feed?;
    return FeedUploadPage(feedToEdit: feed);
  }
}

@TypedGoRoute<PhotoSelectRoute>(path: PhotoSelectRoute.path, name: PhotoSelectRoute.name)
class PhotoSelectRoute extends GoRouteData {
  const PhotoSelectRoute({required this.type});

  final UploadImageType type;

  static const String path = '/photo-select';
  static const String name = 'photo-select';

  @override
  Widget build(BuildContext context, GoRouterState state) => PhotoSelectPage(type: type);
}

@TypedGoRoute<FeedDetailRoute>(path: FeedDetailRoute.path, name: FeedDetailRoute.name)
class FeedDetailRoute extends GoRouteData {
  final String id;

  const FeedDetailRoute({required this.id});

  static const String path = '/feeds/:id';
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
  final bool enableSave;

  const ImageViewerRoute({required this.initialIndex, required this.imageUrls, this.enableSave = false});

  static const String path = '/image-viewer';
  static const String name = 'image-viewer';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ImageViewerPage(imageUrls: imageUrls, initialIndex: initialIndex, enableSave: enableSave);
  }
}

@TypedGoRoute<PostDetailRoute>(path: PostDetailRoute.path, name: PostDetailRoute.name)
class PostDetailRoute extends GoRouteData {
  final String id;

  const PostDetailRoute({required this.id});

  static const String path = '/posts/:id';
  static const String name = 'post-detail';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PostDetailPage(postId: id);
  }
}

@TypedGoRoute<PostUploadRoute>(path: PostUploadRoute.path, name: PostUploadRoute.name)
class PostUploadRoute extends GoRouteData {
  const PostUploadRoute();

  static const String path = '/post-upload';
  static const String name = 'post-upload';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final post = state.extra as Post?;
    return PostUploadPage(postToEdit: post);
  }
}

@TypedGoRoute<AlbumOrganizeRoute>(path: AlbumOrganizeRoute.path, name: AlbumOrganizeRoute.name)
class AlbumOrganizeRoute extends GoRouteData {
  const AlbumOrganizeRoute({required this.$extra});

  final User $extra;

  static const String path = '/album-organize';
  static const String name = 'album-organize';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final user = $extra;
    return AlbumOrganizePage(user: user);
  }
}

@TypedGoRoute<ReportRoute>(path: ReportRoute.path, name: ReportRoute.name)
class ReportRoute extends GoRouteData {
  const ReportRoute({required this.refType, required this.refId});

  final ReportRefType refType;
  final String refId;

  static const String path = '/report';
  static const String name = 'report';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ReportPage(refType: refType, refId: refId);
  }
}

@TypedGoRoute<SettingRoute>(path: SettingRoute.path, name: SettingRoute.name)
class SettingRoute extends GoRouteData {
  const SettingRoute();

  static const String path = '/setting';
  static const String name = 'setting';

  @override
  Widget build(BuildContext context, GoRouterState state) => SettingPage();
}

@TypedGoRoute<NotificationRoute>(path: NotificationRoute.path, name: NotificationRoute.name)
class NotificationRoute extends GoRouteData {
  const NotificationRoute();

  static const String path = '/notification';
  static const String name = 'notification';

  @override
  Widget build(BuildContext context, GoRouterState state) => NotificationPage();
}

@TypedGoRoute<SearchRoute>(path: SearchRoute.path, name: SearchRoute.name)
class SearchRoute extends GoRouteData {
  const SearchRoute({this.keyword});

  // 검색 초기 키워드.
  final String? keyword;

  static const String path = '/search';
  static const String name = 'search';

  @override
  Widget build(BuildContext context, GoRouterState state) => SearchPage(keyword: keyword);
}

@TypedGoRoute<BlockedUsersRoute>(path: BlockedUsersRoute.path, name: BlockedUsersRoute.name)
class BlockedUsersRoute extends GoRouteData {
  const BlockedUsersRoute();

  static const String path = '/blocked-users';
  static const String name = 'blocked-users';

  @override
  Widget build(BuildContext context, GoRouterState state) => BlockedUsersPage();
}
