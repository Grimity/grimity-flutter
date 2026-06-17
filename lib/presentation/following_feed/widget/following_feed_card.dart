import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/util/sync_util.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/following_feed/provider/following_feed_data_provider.dart';
import 'package:grimity/presentation/following_feed/widget/following_feed_comment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readmore/readmore.dart';

class FollowingFeedCard extends ConsumerStatefulWidget {
  const FollowingFeedCard({
    super.key,
    required this.feed,
  });

  final Feed feed;

  @override
  ConsumerState<FollowingFeedCard> createState() => _FollowingFeedCardState();
}

class _FollowingFeedCardState extends ConsumerState<FollowingFeedCard> {
  late Feed feed = widget.feed;

  void onFeedUpdate(Feed newFeed) {
    if (mounted) {
      setState(() => feed = newFeed);
    }
  }

  @override
  void initState() {
    super.initState();
    SyncUtil.feed.listen(feed, onFeedUpdate);
  }

  @override
  void dispose() {
    SyncUtil.feed.cancel(feed, onFeedUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing8),
          child: GdsUserItem.iconId(
            userId: feed.author?.handle ?? '',
            nickName: feed.author?.name ?? '',
            personAvatar: feed.author?.personAvatar ?? GdsPersonAvatar(),
            secondaryActionButton: GdsIconButton(
              icon: GdsIcon.dotMenuHorizontal,
              onPressed: () => _openMoreButton(context),
            ),
          ),
        ),
        Gap(GdsSpacing.spacing8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing12,
          children: [
            Text(
              feed.title,
              style: GdsTypography.title2.copyWith(color: colors.text.grayBold),
            ),

            if (feed.content != null)
              ReadMoreText(
                feed.content!,
                style: GdsTypography.body1R.copyWith(color: colors.text.grayBold),
                trimMode: TrimMode.Line,
                trimLines: 3,
                trimExpandedText: '',
                trimCollapsedText: '더보기',
                moreStyle: GdsTypography.label3.copyWith(color: AppColor.main),
              ),
          ],
        ),
        Gap(GdsSpacing.spacing20),
        GdsGesture(
          onTap: () => _pushFeedDetail(context, feed.id),
          child: GdsThumbnail(
            width: double.infinity,
            imageUrl: feed.cards?.first ?? '',
          ),
        ),
        Gap(GdsSpacing.spacing12),
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing12,
          children: [
            SizedBox(
              height: GdsSpacing.spacing32,
              child: Row(
                spacing: GdsSpacing.spacing8,
                children: [
                  GdsTextButton(
                    size: GdsTextButtonSize.large,
                    text: (feed.likeCount ?? 0).toString(),
                    variant: GdsTextButtonVariant.assistive,
                    iconColor: (feed.isLike ?? false) ? colors.status.notification : null,
                    leadingIcon: (feed.isLike ?? false) ? GdsIcon.heartFill : GdsIcon.heartOutline,
                    onPressed: () {
                      final feedData = ref.read(followingFeedDataProvider.notifier);
                      feedData.toggleLike(feedId: feed.id, like: !(feed.isLike ?? false));
                    },
                  ),
                  IgnorePointer(
                    child: GdsTextButton(
                      size: GdsTextButtonSize.large,
                      text: (feed.commentCount ?? 0).toString(),
                      variant: GdsTextButtonVariant.assistive,
                      leadingIcon: GdsIcon.chatRound,
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
            ),

            if (feed.comment != null) FollowingFeedComment(comment: feed.comment!),
          ],
        ),
      ],
    );
  }

  void _openMoreButton(BuildContext context) {
    final buttons = [
      GrimityModalButtonModel.report(context: context, refType: ReportRefType.feed, refId: feed.id),
      GrimityModalButtonModel(
        title: '유저 프로필로 이동',
        onTap: () {
          context.pop();
          _pushProfile(context, feed.author?.url);
        },
      ),
    ];

    GrimityModalBottomSheet.show(context, buttons: buttons);
  }

  void _pushProfile(BuildContext context, String? profileUrl) {
    if (profileUrl != null) {
      ProfileRoute(url: profileUrl).push(context);
    }
  }

  void _pushFeedDetail(BuildContext context, String feedId) {
    FeedDetailRoute(id: feedId).push(context);
  }
}
