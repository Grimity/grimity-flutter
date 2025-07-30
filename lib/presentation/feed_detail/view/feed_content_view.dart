import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_more_button.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_detail_delete_dialog.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_util_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          Text(feed.title, style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800)),
          Gap(16),
          Row(
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
              GrimityMoreButton(onTap: () => _showMoreBottomSheet(context, isMine, ref)),
            ],
          ),
          Gap(32),
          if (feed.cards != null) ...[
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final imageUrl = feed.cards![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => _FeedImageListPage(imageUrls: feed.cards!, index: index)),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 343.w,
                    fit: BoxFit.fitWidth,
                    placeholder:
                        (context, url) => Skeletonizer(child: Assets.images.imagePlaceholder.image(width: 343.w)),
                    errorWidget: (context, error, stackTrace) => Assets.images.imagePlaceholder.image(width: 343.w),
                  ),
                );
              },
              separatorBuilder: (context, index) => Gap(8),
              itemCount: feed.cards!.length,
              padding: EdgeInsets.zero,
            ),
            Gap(20),
          ],
          Text(
            feed.content ?? '',
            style: TextStyle(fontSize: 16.sp, height: 1.6, letterSpacing: 0, fontWeight: FontWeight.w500),
          ),
          if (feed.tags != null) ...[
            Gap(20),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  feed.tags!
                      .map(
                        (tag) => Container(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColor.gray300, width: 1),
                          ),
                          child: Text(tag, style: AppTypeface.caption3.copyWith(color: AppColor.gray700)),
                        ),
                      )
                      .toList(),
            ),
          ],
          Gap(20),
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
                  // TODO 수정하기 구현 FeedUpload 부분 수정량이 많아 나중에 처리
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
              GrimityModalButtonModel(
                title: '신고하기',
                onTap: () {
                  // TODO 신고하기 페이지 구현시 처리
                },
              ),
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

class _FeedImageListPage extends HookWidget {
  const _FeedImageListPage({required this.imageUrls, required this.index});

  final List<String> imageUrls;
  final int index;

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(index);
    final pageController = usePageController(initialPage: index);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Assets.icons.common.close.svg(
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
            ),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Text('${currentIndex.value + 1} ', style: AppTypeface.body1.copyWith(color: AppColor.main)),
            Text('/ ${imageUrls.length}', style: AppTypeface.body1.copyWith(color: AppColor.gray00)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: imageUrls.length,
                onPageChanged: (index) => currentIndex.value = index,
                itemBuilder: (context, index) {
                  return PhotoView(
                    imageProvider: CachedNetworkImageProvider(imageUrls[index]),
                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 32.h, left: 16.h),
              child: SizedBox(
                height: 48.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == currentIndex.value;
                    return GestureDetector(
                      onTap: () => pageController.jumpToPage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: isSelected ? Border.all(color: AppColor.main, width: 1) : null,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          width: 48.h,
                          height: 48.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
