import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/block/provider/blocked_users_data_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlockedUsersView extends ConsumerWidget {
  const BlockedUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsers = ref.watch(blockedUsersDataProvider);

    return blockedUsers.when(
      data: (data) {
        final users = data;

        if (users.isEmpty) {
          return Container(
            padding: EdgeInsets.only(
              top: GdsSpacing.spacing16,
              left: GdsSpacing.spacing16,
              right: GdsSpacing.spacing16,
              bottom: GdsSpacing.spacing40,
            ),
            alignment: Alignment.center,
            child: GdsEmptyState(title: '차단한 작가가 없어요', icon: GdsIcon.warning),
          );
        }

        return BlockedUserListView(users: users);
      },
      loading: () => Skeletonizer(child: BlockedUserListView(users: User.emptyList)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(blockedUsersDataProvider)),
    );
  }
}

class BlockedUserListView extends ConsumerWidget {
  const BlockedUserListView({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: EdgeInsets.all(GdsSpacing.spacing16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return GdsUserItem.id(
          userId: user.handle,
          nickName: user.name,
          personAvatar: user.personAvatar,
          secondaryActionButton: GdsOutlinedButton(
            size: GdsOutlinedButtonSize.small,
            text: '차단 해제',
            onPressed: () => ref.read(blockedUsersDataProvider.notifier).unblockUser(user.id),
          ),
        );
      },
    );
  }
}
