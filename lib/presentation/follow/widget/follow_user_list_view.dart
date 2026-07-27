import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';

class FollowUserListView extends ConsumerWidget {
  const FollowUserListView({
    super.key,
    required this.users,
    required this.onFollow,
    required this.onUnfollow,
  });

  final List<User> users;
  final ValueChanged<String> onFollow;
  final ValueChanged<String> onUnfollow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing12,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        bottom: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return GdsGesture(
          onTap: () => ProfileRoute(url: user.url).push(context),
          child: GdsUserItem.id(
            userId: user.handle,
            nickName: user.name,
            personAvatar: user.personAvatar,
            primaryActionButton: (user.isFollowing ?? false) ? buildFollowingButton(user) : buildNotFollowButton(user),
          ),
        );
      },
    );
  }

  Widget buildFollowingButton(User user) {
    return GdsOutlinedButton(
      size: GdsOutlinedButtonSize.small,
      text: '팔로잉 중',
      onPressed: () => onUnfollow(user.id),
    );
  }

  Widget buildNotFollowButton(User user) {
    return GdsSolidButton(
      size: GdsSolidButtonSize.small,
      text: '팔로잉',
      onPressed: () => onFollow(user.id),
    );
  }
}
