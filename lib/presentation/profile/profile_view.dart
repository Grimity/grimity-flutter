import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_posts_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/profile/widget/profile_app_bar.dart';
import 'package:grimity/presentation/profile/widget/profile_tab_bar.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({
    super.key,
    required this.user,
    required this.viewType,
    required this.userProfileView,
    required this.feedTabView,
    required this.postTabView,
  });

  final User user;
  final ProfileViewType viewType;
  final Widget userProfileView;
  final Widget feedTabView;
  final Widget? postTabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameOpacity = useState(0.0);
    final userProfileKey = useMemoized(() => GlobalKey());
    final tabController = useTabController(initialLength: postTabView == null ? 1 : 2);

    return Container(
      // 페이지 이동 시 뒤의 페이지가 보이는 문제가 있어 색상 지정 처리.
      color: Colors.white,
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              final RenderBox? renderBox = userProfileKey.currentContext?.findRenderObject() as RenderBox?;
              final double offset = scrollNotification.metrics.pixels;

              if (renderBox != null) {
                final profileHeight = renderBox.size.height;

                final double fadeStartOffset = profileHeight * 0.6;
                final double fadeEndOffset = profileHeight * 0.8;

                if (offset <= fadeStartOffset) {
                  nameOpacity.value = 0.0;
                } else if (offset >= fadeEndOffset) {
                  nameOpacity.value = 1.0;
                } else {
                  nameOpacity.value = (offset - fadeStartOffset) / (fadeEndOffset - fadeStartOffset);
                }
              } else {
                const double fadeStartOffset = 150.0;
                const double fadeEndOffset = 250.0;

                if (offset <= fadeStartOffset) {
                  nameOpacity.value = 0.0;
                } else if (offset >= fadeEndOffset) {
                  nameOpacity.value = 1.0;
                } else {
                  nameOpacity.value = (offset - fadeStartOffset) / (fadeEndOffset - fadeStartOffset);
                }
              }
            }
            return false;
          },
          child: AppBarConnection(
            appBars: [
              AppBar(
                behavior: AbsoluteAppBarBehavior(),
                body: ProfileAppBar(userName: user.name, nameOpacity: nameOpacity.value, viewType: viewType),
              ),
              AppBar(behavior: MaterialAppBarBehavior(), body: Container(key: userProfileKey, child: userProfileView)),
              AppBar(
                behavior: MaterialAppBarBehavior(floating: true),
                body: ProfileTabBar(user: user, tabController: tabController, viewType: viewType),
              ),
            ],
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // pull to refresh 를 프로필 전체 기준으로 하려고 했으나
                // 구조상 하나의 스크롤로 잡기가 어려워 탭 View 기준으로 refresh 처리
                // refresh시 해당 탭 + 사용자 정보까지 업데이트 처리
                GrimityRefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([
                      ref.refresh(profileFeedsDataProvider(user.id).future),
                      ref.refresh(profileDataProvider(user.url).future),
                    ]);
                  },
                  child: GrimityInfiniteScrollPagination(
                    isEnabled:
                        user.id.isNotEmpty &&
                        ref.watch(profileFeedsDataProvider(user.id)).valueOrNull?.nextCursor != null,
                    onLoadMore: () => ref.read(profileFeedsDataProvider(user.id).notifier).loadMore(user.id),
                    child: feedTabView,
                  ),
                ),

                if (postTabView != null)
                  GrimityRefreshIndicator(
                    onRefresh: () async {
                      await Future.wait([
                        ref.refresh(profilePostsDataProvider(user.id).future),
                        ref.refresh(profileDataProvider(user.url).future),
                      ]);
                    },
                    child: GrimityInfiniteScrollPagination(
                      isEnabled:
                          (() {
                            final posts = ref.watch(profilePostsDataProvider(user.id)).valueOrNull;
                            return user.id.isNotEmpty && posts != null && posts.length % 10 == 0;
                          })(),
                      onLoadMore: () => ref.read(profilePostsDataProvider(user.id).notifier).loadMore(user.id),
                      child: postTabView!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
