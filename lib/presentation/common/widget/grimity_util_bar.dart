import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_share_modal_bottom_sheet.dart';

/// 공통 UtilBar
/// 좋아요, 저장, 댓글, 공유 기능 UtilBar
class GrimityUtilBar extends StatelessWidget {
  const GrimityUtilBar({
    super.key,
    required this.isLike,
    required this.isSave,
    required this.likeCount,
    required this.commentCount,
    required this.shareUrl,
    required this.onLikeTap,
    required this.onSaveTap,
  });

  final bool isLike;
  final bool isSave;
  final int likeCount;
  final int commentCount;
  final String shareUrl;

  final VoidCallback onLikeTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.gray00,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GrimityAnimationButton(
                onTap: onLikeTap,
                child:
                    isLike
                        ? Assets.icons.common.heartFill.svg(width: 24, height: 24)
                        : Assets.icons.common.heart.svg(width: 24, height: 24),
              ),
              Gap(6),
              Text('$likeCount', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
              Gap(20),
              Assets.icons.common.reply.svg(width: 24, height: 24),
              Gap(6),
              Text('$commentCount', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
            ],
          ),
          Row(
            children: [
              GrimityAnimationButton(
                child: Assets.icons.common.share.svg(width: 24, height: 24),
                onTap: () => GrimityShareModalBottomSheet.show(context, url: shareUrl),
              ),
              Gap(20),
              GrimityAnimationButton(
                onTap: onSaveTap,
                child:
                    isSave
                        ? Assets.icons.common.saveFill.svg(width: 24, height: 24)
                        : Assets.icons.common.save.svg(width: 24, height: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
