import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/system/more/grimity_more_button.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_detail_delete_dialog.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_util_bar.dart';

/// 피드 본문 View
class FeedContentView extends ConsumerWidget {
  final Feed feed;

  const FeedContentView({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = ref.read(userAuthProvider)?.id == feed.author?.id;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FeedTitleSection(title: feed.title),
          Gap(16),
          _FeedAuthorInfoSection(
            feed: feed,
            isMine: isMine,
            onMoreTap: () => _showMoreBottomSheet(context, isMine, ref),
          ),
          Gap(32),
          if (feed.cards != null) _FeedImageListSection(imageUrls: feed.cards!),
          _FeedContentSection(content: feed.content ?? ''),
          Gap(20),
          if (feed.tags != null) _FeedTagSection(tags: feed.tags!),
          FeedUtilBar(feed: feed),
        ],
      ),
    );
  }

  void _showMoreBottomSheet(BuildContext context, bool isMine, WidgetRef ref) {
    final List<GrimityModalButtonModel> buttons =
        isMine
            ? [
              GrimityModalButtonModel(
                title: '수정하기',
                onTap: () {
                  context.pop();
                  context.push(FeedUploadRoute.path, extra: feed);
                },
              ),
              GrimityModalButtonModel(
                title: '삭제하기',
                onTap: () {
                  context.pop();
                  showDeleteFeedDialog(feed.id, context, ref);
                },
              ),
            ]
            : [
              GrimityModalButtonModel.report(context: context, refType: ReportRefType.feed, refId: feed.id),
              GrimityModalButtonModel(
                title: '유저 프로필로 이동',
                onTap: () {
                  context.pop();
                  ProfileRoute(url: feed.author!.url).go(context);
                },
              ),
            ];

    GrimityModalBottomSheet.show(context, buttons: buttons);
  }
}

class _FeedTitleSection extends StatelessWidget {
  final String title;

  const _FeedTitleSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800));
  }
}

class _FeedAuthorInfoSection extends StatelessWidget {
  const _FeedAuthorInfoSection({required this.feed, required this.isMine, required this.onMoreTap});

  final Feed feed;
  final bool isMine;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GrimityUserImage(imageUrl: feed.author?.image, size: 30),
        Gap(8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feed.author?.name ?? '작성자 정보 없음',
                style: AppTypeface.label2.copyWith(color: AppColor.gray700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    feed.createdAt == null ? '알 수 없음' : feed.createdAt!.toRelativeTime(),
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  ),
                  GrimityGrayCircle(),
                  Assets.icons.common.like.svg(width: 16, height: 16),
                  Gap(2),
                  Text('${feed.likeCount}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                  GrimityGrayCircle(),
                  Assets.icons.common.view.svg(width: 16, height: 16),
                  Gap(2),
                  Text('${feed.viewCount}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                ],
              ),
            ],
          ),
        ),
        if (!isMine) ...[if (feed.author != null) GrimityFollowButton(url: feed.author!.url), Gap(10)],
        GrimityMoreButton.decorated(onTap: onMoreTap),
      ],
    );
  }
}

class _FeedImageListSection extends StatelessWidget {
  final List<String> imageUrls;

  const _FeedImageListSection({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final imageUrl = imageUrls[index];
            return GestureDetector(
              onTap: () {
                ImageViewerRoute(initialIndex: index, imageUrls: imageUrls).push(context);
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 343.w,
                fit: BoxFit.fitWidth,
                placeholder: (_, __) => Assets.images.imagePlaceholder.image(width: 343.w),
                errorWidget: (_, __, ___) => Assets.images.imagePlaceholder.image(width: 343.w),
              ),
            );
          },
          separatorBuilder: (_, __) => Gap(8),
        ),
        Gap(20),
      ],
    );
  }
}

class _FeedContentSection extends StatelessWidget {
  final String content;

  const _FeedContentSection({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content, style: TextStyle(fontSize: 16.sp, height: 1.6, letterSpacing: 0, fontWeight: FontWeight.w500));
  }
}

class _FeedTagSection extends StatelessWidget {
  final List<String> tags;

  const _FeedTagSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Wrap(spacing: 6, runSpacing: 6, children: tags.map((tag) => _buildTag(tag)).toList()), Gap(20)],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColor.gray300, width: 1),
      ),
      child: Text(tag, style: AppTypeface.caption3.copyWith(color: AppColor.gray700)),
    );
  }
}
