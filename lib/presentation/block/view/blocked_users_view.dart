import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/block/provider/blocked_users_data_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_profile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlockedUsersView extends ConsumerWidget {
  const BlockedUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsers = ref.watch(blockedUsersDataProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: blockedUsers.when(
        data: (data) {
          final users = data;

          if (users.isEmpty) {
            return GrimityStateView.resultNull(
              subTitle: '아직 차단한 유저가 없어요',
            );
          }

          return BlockedUserListView(users: users);
        },
        loading: () => Skeletonizer(child: BlockedUserListView(users: User.emptyList)),
        error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(blockedUsersDataProvider)),
      ),
    );
  }
}

class BlockedUserListView extends ConsumerWidget {
  const BlockedUserListView({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Row(
          children: [
            Expanded(
              child: GrimityUserProfile.fromString(
                title: user.name,
                imageUrl: user.image,
              ),
            ),
            GrimityButton.round(
              text: '차단 해제',
              onTap: () => ref.read(blockedUsersDataProvider.notifier).unblockUser(user.id),
              style: ButtonStyleType.line,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Gap(16);
      },
    );
  }
}
