import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_share_modal_bottom_sheet.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';

class FeedUtilBar extends ConsumerWidget {
  final Feed feed;

  const FeedUtilBar({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLike = feed.isLike ?? false;
    final isSave = feed.isSave ?? false;

    return Container(
      color: AppColor.gray00,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GrimityAnimationButton(
                onTap: () => ref.read(feedDetailDataProvider(feed.id).notifier).toggleLikeFeed(feed.id, !isLike),
                child:
                    isLike
                        ? Assets.icons.common.heartFill.svg(width: 24, height: 24)
                        : Assets.icons.common.heart.svg(width: 24, height: 24),
              ),
              Gap(6),
              Text('${feed.likeCount ?? 0}', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
              Gap(20),
              Assets.icons.common.reply.svg(width: 24, height: 24),
              Gap(6),
              Text('${feed.commentCount ?? 0}', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
            ],
          ),
          Row(
            children: [
              GrimityAnimationButton(
                child: Assets.icons.common.share.svg(width: 24, height: 24),
                onTap: () => GrimityShareModalBottomSheet.show(context, url: '${AppConfig.apiUrl}feeds/${feed.id}'),
              ),
              Gap(20),
              GrimityAnimationButton(
                child:
                    isSave
                        ? Assets.icons.common.saveFill.svg(width: 24, height: 24)
                        : Assets.icons.common.save.svg(width: 24, height: 24),
                onTap: () => ref.read(feedDetailDataProvider(feed.id).notifier).toggleSaveFeed(feed.id, !isSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
