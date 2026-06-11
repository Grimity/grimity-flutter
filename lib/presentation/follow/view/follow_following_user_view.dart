import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/follow/provider/follow_followers_data_provider.dart';
import 'package:grimity/presentation/follow/widget/follow_user_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowingUserView extends HookConsumerWidget {
  const FollowingUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final users = ref.watch(followersDataProvider);

    return users.when(
      data: (data) {
        final users = data.users;

        if (users.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(
              top: GdsSpacing.spacing12,
              bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
            ),
            child: GdsEmptyState(
              size: context.isMobile ? GdsEmptyStateSize.md : GdsEmptyStateSize.xl,
              icon: GdsIcon.user,
              title: '팔로우한 작가가 없어요',
              action: GdsSolidButton(
                size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
                text: '인기 그림 둘러보기',
                onPressed: () => const RankingRoute().go(context),
              ),
            ),
          );
        }

        return GrimityInfiniteScrollPagination(
          onLoadMore: ref.read(followersDataProvider.notifier).loadMore,
          isEnabled: data.nextCursor != null,
          child: FollowUserListView(users: users),
        );
      },
      loading: () => Skeletonizer(child: FollowUserListView(users: User.emptyList)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(followersDataProvider)),
    );
  }
}
