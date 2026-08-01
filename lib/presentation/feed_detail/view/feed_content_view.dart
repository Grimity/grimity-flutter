import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/presentation/common/extension/user_ui_extension.dart';
import 'package:grimity/presentation/common/hook/layer_link.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_popup.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_detail_delete_dialog.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_util_bar.dart';
import 'package:grimity/presentation/report/report_page.dart';
import 'package:url_launcher/url_launcher.dart';

/// 피드 본문 View
class FeedContentView extends ConsumerWidget {
  const FeedContentView({
    super.key,
    required this.feed,
  });

  final Feed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = ref.read(userAuthProvider)?.id == feed.author?.id;

    return Padding(
      padding: EdgeInsets.only(
        top: context.isMobile ? GdsSpacing.spacing8 : GdsSpacing.spacing24,
        left: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        right: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FeedAuthorInfoSection(
            feed: feed,
            isMine: isMine,
            onMoreTap: (link) => showMorePopup(context, feed, isMine, false, ref, link, GdsMenuPosition.right),
            onShareTap: () => showSharePopup(context, feed),
          ),
          Gap(GdsSpacing.spacing8),
          if (feed.cards != null) _FeedImageListSection(imageUrls: feed.cards!),
          Gap(GdsSpacing.spacing20),
          _FeedContentSection(feed: feed),
          if (feed.tags != null) ...[
            Gap(GdsSpacing.spacing24),
            _FeedTagSection(tags: feed.tags!),
          ],
          if (feed.author?.isBlocked == false) ...[
            Gap(GdsSpacing.spacing32),
            FeedUtilBar(feed: feed),
          ],
        ],
      ),
    );
  }

  static Future<void> showSharePopup(BuildContext context, Feed feed) {
    final popup = GrimitySharePopup(
      url: AppConfig.buildFeedUrl(feed.id),
      shareContentType: ShareContentType.feed,
      description: feed.title,
      imageUrl: feed.thumbnail,
    );

    return popup.show(context);
  }

  static Future<void> showMorePopup(
    BuildContext context,
    Feed feed,
    bool isMine,
    bool showShare,
    WidgetRef ref,
    LayerLink layerLink,
    GdsMenuPosition position,
  ) {
    final List<GdsMenuItem> items = [
      if (isMine) ...[
        if (showShare)
          GdsMenuItem(
            label: '공유하기',
            onTap: () {
              context.pop();
              showSharePopup(context, feed);
            },
          ),
        GdsMenuItem(
          label: '수정하기',
          onTap: () {
            context.pop();
            context.push(FeedUploadRoute.path, extra: feed);
          },
        ),
        GdsMenuItem(
          label: '삭제하기',
          onTap: () {
            context.pop();
            showDeleteFeedAlert(feed.id, context, ref);
          },
        ),
      ] else ...[
        if (showShare)
          GdsMenuItem(
            label: '공유하기',
            onTap: () {
              context.pop();
              showSharePopup(context, feed);
            },
          ),
        GdsMenuItem(
          label: '유저 프로필로 이동',
          onTap: () {
            context.pop();
            ProfileRoute(url: feed.author!.url).push(context);
          },
        ),
        GdsMenuItem(
          label: '신고하기',
          onTap: () {
            context.pop();
            ReportPage.push(context, refId: feed.id, refType: ReportRefType.feed);
          },
        ),
      ],
    ];

    final popup = GrimityMenuPopup(
      items: items,
      layerLink: layerLink,
    );

    return popup.show(context, position);
  }
}

class _FeedAuthorInfoSection extends HookWidget {
  const _FeedAuthorInfoSection({
    required this.feed,
    required this.isMine,
    required this.onMoreTap,
    required this.onShareTap,
  });

  final Feed feed;
  final bool isMine;
  final Function(LayerLink) onMoreTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    final layerLink = useLayerLink();

    return GdsUserItem.iconId(
      userId: feed.author?.handle ?? '',
      nickName: feed.author?.name ?? '',
      personAvatar: feed.author?.personAvatar ?? GdsPersonAvatar(),
      primaryActionButton: GdsIconButton.normal(
        icon: GdsIcon.share,
        onPressed: onShareTap,
      ),
      secondaryActionButton: GdsIconButton.normal(
        icon: GdsIcon.dotMenuHorizontal,
        onPressed: () => onMoreTap(layerLink),
      ),
      onProfileTap: () {
        ProfileRoute(url: feed.author!.url).push(context);
      },
    );
  }
}

class _FeedImageListSection extends StatelessWidget {
  const _FeedImageListSection({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: GdsSpacing.spacing12,
      children: [
        ...imageUrls.mapIndexed((index, imageUrl) {
          return GdsGesture(
            onTap: () {
              // 이미지 뷰어 페이지로 이동
              ImageViewerRoute(initialIndex: index, imageUrls: imageUrls).push(context);
            },
            child: GrimityCachedNetworkImage.fitWidth(imageUrl: imageUrl),
          );
        }),
      ],
    );
  }
}

class _FeedContentSection extends StatelessWidget {
  const _FeedContentSection({required this.feed});

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          feed.title,
          style: GdsTypography.title3.copyWith(color: colors.text.grayBold),
        ),
        Gap(context.isMobile ? GdsSpacing.spacing8 : GdsSpacing.spacing20),
        Linkify(
          text: feed.content ?? '',
          style: GdsTypography.body2R.copyWith(color: colors.text.grayBold),
          linkStyle: GdsTypography.body2R.copyWith(
            color: colors.text.primaryNormal,
            decoration: TextDecoration.none,
            decorationColor: colors.text.primaryNormal,
          ),
          options: const LinkifyOptions(defaultToHttps: true),
          onOpen: (link) => launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication),
        ),
        Gap(GdsSpacing.spacing16),
        GdsUserInfo.defaultType(
          nickName: feed.author?.name ?? '',
          heartCount: feed.likeCount,
          viewCount: feed.viewCount,
          timeText: feed.createdAt?.toRelativeTime() ?? '',
          showNickName: false,
          showHeart: true,
          showView: true,
          showTime: true,
        ),
      ],
    );
  }
}

class _FeedTagSection extends StatelessWidget {
  final List<String> tags;

  const _FeedTagSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: GdsSpacing.spacing8,
      runSpacing: GdsSpacing.spacing8,
      children: tags.map((tag) => _buildTag(context, tag)).toList(),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return GdsTag(
      size: context.isMobile ? GdsTagSize.small : GdsTagSize.medium,
      text: tag,
      onTap: () => SearchRoute(keyword: tag).push(context),
    );
  }
}
