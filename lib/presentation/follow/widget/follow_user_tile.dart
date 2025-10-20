import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_profile.dart';

enum FollowType {
  // 팔로워
  follower,
  // 팔로잉
  following,
}

// 팔로워, 팔로우 유저 표시 위젯
class FollowUserTile extends StatelessWidget {
  final User user;
  final FollowType followType;
  final VoidCallback onFollowTap;

  const FollowUserTile._({super.key, required this.user, required this.followType, required this.onFollowTap});

  factory FollowUserTile.follower({Key? key, required User user, required VoidCallback onFollowTap}) {
    return FollowUserTile._(key: key, user: user, followType: FollowType.follower, onFollowTap: onFollowTap);
  }

  factory FollowUserTile.following({Key? key, required User user, required VoidCallback onFollowTap}) {
    return FollowUserTile._(key: key, user: user, followType: FollowType.following, onFollowTap: onFollowTap);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56.h),
      child: Row(
        children: [
          Expanded(
            child: GrimityUserProfile.fromString(
              imageUrl: user.image ?? '',
              title: user.name,
              subTitle: user.description ?? '',
            ),
          ),
          Gap(20.w),
          switch (followType) {
            FollowType.follower => GrimityButton.deleteFollower(onTap: onFollowTap),
            FollowType.following => GrimityButton.follow(isFollowing: true, onTap: onFollowTap),
          },
        ],
      ),
    );
  }
}
