import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/extension/image_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/system/more/grimity_more_button.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readmore/readmore.dart';

class FollowingFeedCard extends ConsumerWidget {
  const FollowingFeedCard({super.key, required this.feed});

  final Feed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GrimityGesture(
                      onTap: () => _goProfile(context, feed.author?.url),
                      child: Row(
                        children: [
                          GrimityUserImage(imageUrl: feed.author?.image ?? '', size: 24),
                          Gap(6),
                          Text(
                            feed.author?.name ?? '작성자 정보 없음',
                            style: AppTypeface.caption1.copyWith(color: AppColor.gray600),
                          ),
                        ],
                      ),
                    ),
                    GrimityGrayCircle(),
                    Text(
                      feed.createdAt?.toRelativeTime() ?? DateTime.now().toRelativeTime(),
                      style: AppTypeface.caption1.copyWith(color: AppColor.gray600),
                    ),
                    Spacer(),
                    GrimityMoreButton.plain(
                      onTap: () {
                        final buttons = [
                          GrimityModalButtonModel.report(context: context, refType: ReportRefType.feed, refId: feed.id),
                          GrimityModalButtonModel(
                            title: '유저 프로필로 이동',
                            onTap: () {
                              context.pop();
                              _goProfile(context, feed.author?.url);
                            },
                          ),
                        ];

                        GrimityModalBottomSheet.show(context, buttons: buttons);
                      },
                    ),
                  ],
                ),
                Gap(8),
                GrimityGesture(
                  onTap: () => _pushFeedDetail(context, feed.id),
                  child: Text(feed.title, style: AppTypeface.subTitle4.copyWith(color: AppColor.gray800)),
                ),
                Gap(6),
                GrimityGesture(
                  onTap: () => _pushFeedDetail(context, feed.id),
                  child: ReadMoreText(
                    feed.content ?? '',
                    style: AppTypeface.label3.copyWith(color: AppColor.gray800),
                    trimMode: TrimMode.Line,
                    trimLines: 3,
                    trimExpandedText: '',
                    trimCollapsedText: '더보기',
                    moreStyle: AppTypeface.label2.copyWith(color: AppColor.main),
                  ),
                ),
              ],
            ),
          ),
          Gap(20),
          AspectRatio(
            aspectRatio: 1.0,
            child:
                (feed.cards?.isNotEmpty ?? false)
                    ? _FollowingFeedCardImageCarousel(imageList: feed.cards!)
                    : _imageSkeleton,
          ),
          Gap(12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GrimityAnimationButton(
                  onTap:
                      () => ref
                          .read(followingFeedDataProvider.notifier)
                          .toggleLike(feedId: feed.id, like: !(feed.isLike ?? false)),
                  child:
                      feed.isLike ?? false
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
          ),
          if (feed.comment != null) ...[
            Gap(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GrimityGesture(
                onTap: () => _pushFeedDetail(context, feed.id),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(color: AppColor.gray200, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      GrimityUserImage(imageUrl: feed.comment!.writer?.image ?? '', size: 24),
                      Gap(6),
                      Flexible(
                        child: Text(
                          feed.comment!.content,
                          style: AppTypeface.caption2.copyWith(color: AppColor.gray700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 스켈레톤 효과를 위한 팔로잉 피드 사진 플레이스 홀더
  Widget get _imageSkeleton => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Container(width: 343.w, height: 343.w, color: AppColor.gray400),
  );

  void _goProfile(BuildContext context, String? profileUrl) {
    if (profileUrl != null) {
      AppRouter.goProfile(context, targetUrl: profileUrl);
    }
  }

  void _pushFeedDetail(BuildContext context, String feedId) {
    FeedDetailRoute(id: feedId).push(context);
  }
}

class _FollowingFeedCardImageCarousel extends StatelessWidget {
  const _FollowingFeedCardImageCarousel({required this.imageList});

  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imageList.length,
      options: CarouselOptions(
        enableInfiniteScroll: false,
        disableCenter: true,
        padEnds: false,
        viewportFraction: 0.97,
      ),
      itemBuilder: (context, index, realIndex) {
        final imageUrl = imageList[index];
        return Container(
          padding: EdgeInsets.only(left: index == 0 ? 16 : 4, right: index == imageList.length - 1 ? 16 : 4),
          child: GrimityGesture(
            onTap: () {
              ImageViewerRoute(initialIndex: index, imageUrls: imageList).push(context);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                GrimityCachedNetworkImage.fitWidth(
                  imageUrl: imageUrl,
                  width: 343.w,
                  placeholder:
                      (_, __) =>
                          Assets.images.imagePlaceholder.image(width: 343.w, cacheWidth: 343.w.cacheSize(context)),
                  errorWidget:
                      (_, __, ___) =>
                          Assets.images.imagePlaceholder.image(width: 343.w, cacheWidth: 343.w.cacheSize(context)),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColor.gray800.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}/${imageList.length}',
                      style: AppTypeface.caption4.copyWith(color: AppColor.gray100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
