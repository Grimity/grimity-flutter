import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';
import 'package:grimity/presentation/follow/provider/follow_following_data_provider.dart';

class FollowUserListView extends ConsumerWidget {
  const FollowUserListView({
    super.key,
    required this.users,
  });

  final List<User> users;

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
            primaryActionButton:
                (user.isFollowing ?? false) ? buildFollowingButton(user, ref) : buildNotFollowButton(user, ref),
          ),
        );
      },
    );
  }

  Widget buildFollowingButton(User user, WidgetRef ref) {
    return GdsOutlinedButton(
      size: GdsOutlinedButtonSize.small,
      text: '팔로잉 중',
      onPressed: () => ref.read(followingDataProvider.notifier).unfollow(user.id),
    );
  }

  Widget buildNotFollowButton(User user, WidgetRef ref) {
    return GdsSolidButton(
      size: GdsSolidButtonSize.small,
      text: '팔로잉',
      onPressed: () => ref.read(followingDataProvider.notifier).follow(user.id),
    );
  }
}
