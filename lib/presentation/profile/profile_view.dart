import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
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
    required this.userProfileView,
    required this.feedTabView,
    required this.postTabView,
  });

  final User user;
  final Widget userProfileView;
  final Widget feedTabView;
  final Widget? postTabView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameOpacity = useState(0.0);
    final tabController = useTabController(initialLength: postTabView == null ? 1 : 2);

    return Scaffold(
      endDrawer: MainAppDrawer(),
      body: SafeArea(
        child: AppBarConnection(
          appBars: [
            AppBar(
              behavior: AbsoluteAppBarBehavior(),
              body: ProfileAppBar(userName: user.name, nameOpacity: nameOpacity.value),
            ),
            AppBar.builder(
              behavior: MaterialAppBarBehavior(alignAnimation: false),
              builder: (context, position) {
                // AppBar 스크롤 진행도(0.0 ~ 1.0)
                final offset = position.offset;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  const fadeStartOffset = 0.6;
                  const fadeEndOffset = 0.8;

                  // 0.6 이하인 경우 이름 미표시
                  if (offset <= fadeStartOffset) {
                    nameOpacity.value = 0.0;
                  }
                  // 0.8 이상인 경우는 이름 표시
                  else if (offset >= fadeEndOffset) {
                    nameOpacity.value = 1.0;
                  }
                  // 0.6 ~ 0.8 사이 구간은 fade 처리
                  else {
                    nameOpacity.value = (offset - fadeStartOffset) / (fadeEndOffset - fadeStartOffset);
                  }
                });
                return userProfileView;
              },
            ),
            AppBar(
              behavior: AbsoluteAppBarBehavior(),
              body: ProfileTabBar(user: user, tabController: tabController),
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
    );
  }
}
