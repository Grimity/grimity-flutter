import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/author_with_feeds_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_image.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class GrimityAuthorWithFeedsCard extends StatelessWidget {
  const GrimityAuthorWithFeedsCard({super.key, required this.authorWithFeeds, required this.onFollowTab});

  final AuthorWithFeeds authorWithFeeds;
  final VoidCallback onFollowTab;

  @override
  Widget build(BuildContext context) {
    final user = authorWithFeeds.user;
    final feeds = authorWithFeeds.feeds;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.gray300, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GrimityUserImage(imageUrl: user.image, size: 30),
              Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '팔로워 ', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                        TextSpan(text: '${user.followerCount}', style: AppTypeface.caption1),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              GrimityButton.follow(isFollowing: user.isFollowing ?? false, onTap: onFollowTab),
            ],
          ),
          Gap(20),
          SizedBox(
            height: 110.h,
            child: Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                if (index < feeds.length) {
                  return Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: GrimityImage.small(imageUrl: feeds[index].thumbnail ?? ''),
                    ),
                  );
                } else {
                  return Expanded(child: AspectRatio(aspectRatio: 1, child: Assets.images.imagePlaceholder.image()));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
