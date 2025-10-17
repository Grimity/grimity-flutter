import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class GrimityUserCard extends StatelessWidget {
  const GrimityUserCard({super.key, required this.user, required this.onFollowTap});

  final User user;
  final VoidCallback onFollowTap;

  final double _coverHeight = 110;
  final double _avatarSize = 40;
  final double _overlap = 36;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProfileRoute(url: user.url).go(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(12),
          border: Border.all(color: AppColor.gray300, width: 1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(12)),
              child: GrimityProfileBackgroundImage(url: user.backgroundImage, height: _coverHeight),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16 + (_coverHeight - _overlap), bottom: 20),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      GrimityUserImage(imageUrl: user.image, size: _avatarSize),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Row(
                            children: [
                              Text(user.name, style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
                              GrimityGrayCircle(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '팔로워 ',
                                      style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                                    ),
                                    TextSpan(text: '${user.followerCount}', style: AppTypeface.caption1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (user.description?.isNotEmpty ?? false)
                            Text(
                              user.description!,
                              style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 26,
                    right: 0,
                    child: GrimityButton.follow(isFollowing: user.isFollowing ?? false, onTap: onFollowTap),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
