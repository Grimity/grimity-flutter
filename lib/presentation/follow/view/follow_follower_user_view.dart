import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/follow/widget/follow_user_tile.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:grimity/presentation/follow/provider/follow_followers_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

// 팔로워 뷰
class FollowerUserView extends HookConsumerWidget {
  const FollowerUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final users = ref.watch(followersDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: users.when(
        data: (data) {
          final users = data.users;

          if (users.isEmpty) {
            return GrimityStateView.user(subTitle: FollowTabType.follower.emptyMessage);
          }

          return GrimityInfiniteScrollPagination(
            isEnabled: data.nextCursor != null,
            onLoadMore: ref.read(followersDataProvider.notifier).loadMore,
            child: _FollowerUserListView(users: data.users),
          );
        },
        loading: () => Skeletonizer(child: _FollowerUserListView(users: User.emptyList)),
        error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(followersDataProvider)),
      ),
    );
  }
}

class _FollowerUserListView extends ConsumerWidget {
  const _FollowerUserListView({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = users[index];
        return FollowUserTile.follower(
          user: user,
          onFollowTap: () => ref.read(followersDataProvider.notifier).deleteFollower(user.id),
        );
      },
      separatorBuilder: (context, index) => Gap(16.h),
      itemCount: users.length,
    );
  }
}
