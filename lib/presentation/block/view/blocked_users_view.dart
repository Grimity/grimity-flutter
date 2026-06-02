import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/block/provider/blocked_users_data_provider.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BlockedUsersView extends ConsumerWidget {
  const BlockedUsersView({
    super.key,
    this.isModal = false,
  });

  /// 모달 여부에 따라 다른 레이아웃과 패딩을 적용할 여부
  final bool isModal;

  /// 페이지에서 사용할 때의 기본 패딩 정의
  static EdgeInsets padding = EdgeInsets.only(
    top: GdsSpacing.spacing16,
    left: GdsSpacing.spacing16,
    right: GdsSpacing.spacing16,
    bottom: GdsSpacing.spacing40,
  );

  /// 모달에서 사용할 때의 별도의 패딩 정의
  static EdgeInsets modalPadding = EdgeInsets.only(
    top: GdsSpacing.spacing8,
    left: GdsSpacing.spacing20,
    right: GdsSpacing.spacing20,
    bottom: GdsSpacing.spacing20,
  );

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

        return BlockedUserListView(users: users, isModal: isModal);
      },
      loading: () => Skeletonizer(child: BlockedUserListView(users: User.emptyList, isModal: isModal)),
      error: (e, s) => GrimityStateView.error(onTap: () => ref.invalidate(blockedUsersDataProvider)),
    );
  }
}

class BlockedUserListView extends ConsumerWidget {
  const BlockedUserListView({
    super.key,
    required this.users,
    required this.isModal,
  });

  final List<User> users;
  final bool isModal;

  /// 페이지에서 사용할 때의 기본 패딩 정의
  static EdgeInsets padding = EdgeInsets.all(GdsSpacing.spacing16);

  /// 모달에서 사용할 때의 별도의 패딩 정의
  static EdgeInsets modalPadding = BlockedUsersView.modalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: isModal ? modalPadding : padding,
      shrinkWrap: isModal ? true : false,
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
