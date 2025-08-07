import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_follow_user_tile.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';
import 'package:grimity/presentation/follow/provider/follow_followers_data_provider.dart';
import 'package:grimity/presentation/follow/view/follow_empty_view.dart';
import 'package:grimity/presentation/home/hook/use_infinite_scroll_hook.dart';
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
      child: users.maybeWhen(
        data:
            (data) =>
                data.users.isEmpty
                    ? FollowEmptyView(type: FollowTabType.follower)
                    : _FollowerUserListView(users: data.users),
        orElse: () => Skeletonizer(child: _FollowerUserListView(users: User.emptyList)),
      ),
    );
  }
}

class _FollowerUserListView extends HookConsumerWidget {
  const _FollowerUserListView({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useInfiniteScrollHook(
      ref: ref,
      scrollController: scrollController,
      loadFunction: () async => await ref.read(followersDataProvider.notifier).loadMore(),
    );

    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        final user = users[index];
        return FollowUserTile.withButton(
          user: user,
          buttonText: '삭제',
          onButtonTap: () => ref.read(followersDataProvider.notifier).deleteFollower(user.id),
        );
      },
      separatorBuilder: (context, index) => Gap(16.h),
      itemCount: users.length,
    );
  }
}
