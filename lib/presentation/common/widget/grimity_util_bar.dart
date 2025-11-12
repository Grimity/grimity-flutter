import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_modal_bottom_sheet.dart';

/// 공통 UtilBar
/// 좋아요, 저장, 댓글, 공유 기능 UtilBar
class GrimityUtilBar extends ConsumerWidget {
  const GrimityUtilBar({
    super.key,
    required this.isLike,
    required this.isSave,
    required this.likeCount,
    required this.commentCount,
    required this.shareUrl,
    required this.onLikeTap,
    required this.onSaveTap,
    required this.shareContentType,
    required this.title,
    required this.thumbnail,
    required this.commentType,
  });

  final bool isLike;
  final bool isSave;
  final int likeCount;
  final int commentCount;
  final String shareUrl;
  final ShareContentType shareContentType;
  final String title;
  final String? thumbnail;
  final CommentType commentType;

  final VoidCallback onLikeTap;
  final VoidCallback onSaveTap;

  factory GrimityUtilBar.feed({
    required bool isLike,
    required bool isSave,
    required int likeCount,
    required int commentCount,
    required String shareUrl,
    required String title,
    required String? thumbnail,
    required VoidCallback onLikeTap,
    required VoidCallback onSaveTap,
  }) => GrimityUtilBar(
    isLike: isLike,
    isSave: isSave,
    likeCount: likeCount,
    commentCount: commentCount,
    shareUrl: shareUrl,
    onLikeTap: onLikeTap,
    onSaveTap: onSaveTap,
    shareContentType: ShareContentType.feed,
    title: title,
    thumbnail: thumbnail,
    commentType: CommentType.feed,
  );

  factory GrimityUtilBar.post({
    required bool isLike,
    required bool isSave,
    required int likeCount,
    required int commentCount,
    required String shareUrl,
    required String title,
    required String? thumbnail,
    required VoidCallback onLikeTap,
    required VoidCallback onSaveTap,
  }) => GrimityUtilBar(
    isLike: isLike,
    isSave: isSave,
    likeCount: likeCount,
    commentCount: commentCount,
    shareUrl: shareUrl,
    onLikeTap: onLikeTap,
    onSaveTap: onSaveTap,
    shareContentType: ShareContentType.post,
    title: title,
    thumbnail: thumbnail,
    commentType: CommentType.post,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              GrimityGesture(
                onTap: () {
                  final notifier = ref.read(commentInputProvider(commentType).notifier);
                  notifier.requestFocus?.call();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Assets.icons.common.reply.svg(width: 24, height: 24),
                    Text('$commentCount', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              GrimityAnimationButton(
                child: Assets.icons.common.share.svg(width: 24, height: 24),
                onTap:
                    () => GrimityShareModalBottomSheet.show(
                      context,
                      url: shareUrl,
                      shareContentType: shareContentType,
                      description: title,
                      imageUrl: thumbnail,
                    ),
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
