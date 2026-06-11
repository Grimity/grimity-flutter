import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/follow/widget/follow_user_list_view.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/follow/provider/follow_following_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FollowerUserView extends HookConsumerWidget {
  const FollowerUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final users = ref.watch(followingDataProvider);

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
              title: '빛나는 나를 알아본 사람이 아직 없어요',
              action: GdsSolidButton(
                size: context.isMobile ? GdsSolidButtonSize.regular : GdsSolidButtonSize.large,
                text: '그림 올리기',
                onPressed: () => const FeedUploadRoute().push(context),
              ),
            ),
          );
        }

        return GrimityInfiniteScrollPagination(
          onLoadMore: ref.read(followingDataProvider.notifier).loadMore,
          isEnabled: data.nextCursor != null,
          child: FollowUserListView(users: data.users),
        );
      },

      loading: () => Skeletonizer(child: FollowUserListView(users: User.emptyList)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(followingDataProvider)),
    );
  }
}
