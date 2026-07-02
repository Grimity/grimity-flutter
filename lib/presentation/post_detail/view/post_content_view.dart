import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/app/util/color_util.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_popup.dart';
import 'package:grimity/presentation/post_detail/widget/post_detail_delete_alert.dart';
import 'package:grimity/presentation/post_detail/widget/post_util_bar.dart';
import 'package:grimity/presentation/report/report_page.dart';

class PostContentView extends ConsumerWidget {
  const PostContentView({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = ref.read(userAuthProvider)?.id == post.author?.id;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeaderSection(post: post, isMine: isMine),
          Gap(GdsSpacing.spacing20),
          _PostContentSection(post: post),
          Gap(GdsSpacing.spacing16),
          _PostUserInfoSection(post: post),
          Gap(GdsSpacing.spacing32),
          PostUtilBar(post: post),
        ],
      ),
    );
  }

  static Future<void> showMoreMenu(
    BuildContext context, {
    required Post post,
    required bool isMine,
    required WidgetRef ref,
    required LayerLink layerLink,
    required bool showShare,
  }) {
    final items = [
      if (isMine) ...[
        GdsMenuItem(
          label: '수정하기',
          onTap: () {
            context.pop();
            context.push(PostUploadRoute.path, extra: post);
          },
        ),
        GdsMenuItem(
          label: '삭제하기',
          onTap: () {
            context.pop();
            showDeletePostAlert(post, context, ref);
          },
        ),
      ] else ...[
        GdsMenuItem(
          label: '작가 프로필로 이동',
          onTap: () {
            context.pop();
            ProfileRoute(url: post.author!.url).push(context);
          },
        ),
        GdsMenuItem(
          label: '신고하기',
          onTap: () {
            context.pop();
            ReportPage.push(context, refId: post.id, refType: ReportRefType.post);
          },
        ),
      ],
    ];

    if (showShare) {
      final newItem = GdsMenuItem(
        label: '공유하기',
        onTap: () {
          context.pop();
          showSharePopup(context, post);
        },
      );

      items.insert(0, newItem);
    }

    final popup = GrimityMenuPopup(layerLink: layerLink, items: items);
    return popup.show(context, GdsMenuPosition.right);
  }

  static Future<void> showSharePopup(BuildContext context, Post post) {
    final popup = GrimitySharePopup(
      url: AppConfig.buildPostUrl(post.id),
      shareContentType: ShareContentType.post,
      description: post.content,
      imageUrl: post.thumbnail,
    );

    return popup.show(context);
  }
}

class _PostHeaderSection extends ConsumerWidget {
  const _PostHeaderSection({
    required this.post,
    required this.isMine,
  });

  final Post post;
  final bool isMine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final postType = post.type == null ? null : PostType.fromString(post.type!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: context.isMobile ? GdsSpacing.spacing8 : GdsSpacing.spacing12,
      children: [
        GdsChip(
          text: postType?.displayName ?? '',
          size: context.isMobile ? GdsChipSize.medium : GdsChipSize.xLarge,
          variant: postType?.chipVariant ?? GdsChipVariant.assistive,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: GdsSpacing.spacing12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: GdsSpacing.spacing8,
                children: [
                  Text(
                    post.title,
                    style:
                        context.isMobile
                            ? GdsTypography.title3.copyWith(color: colors.text.grayBold)
                            : GdsTypography.title2.copyWith(color: colors.text.grayBold),
                  ),
                  Text(
                    post.author?.name ?? '',
                    style: GdsTypography.label6.copyWith(color: colors.text.graySubtle),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing4,
              children: [
                GdsMenuAnchor(
                  builder: (link) {
                    return GdsIconButton(
                      icon: GdsIcon.dotMenuHorizontal,
                      onPressed: () {
                        PostContentView.showMoreMenu(
                          context,
                          post: post,
                          isMine: isMine,
                          ref: ref,
                          layerLink: link,
                          showShare: false,
                        );
                      },
                    );
                  },
                ),
                GdsIconButton(
                  icon: GdsIcon.share,
                  onPressed: () => PostContentView.showSharePopup(context, post),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Detail의 content는 Html 형식
class _PostContentSection extends StatelessWidget {
  const _PostContentSection({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return HtmlWidget(
      post.content,
      textStyle: GdsTypography.body2R.copyWith(color: colors.text.grayBold),
      renderMode: RenderMode.column,
      customWidgetBuilder: (e) {
        /// p태그 하나에 여러개 br이 있는 경우 p태그의 마진이 동작하지 않음
        /// br태그에 p 마진 값 추가
        if (e.localName == 'br') {
          return Gap(6);
        }

        if (e.localName == 'img') {
          final imageUrl = e.attributes['src'] ?? '';

          return Padding(
            padding: EdgeInsets.only(
              bottom: context.isMobile ? GdsSpacing.spacing12 : GdsSpacing.spacing20,
            ),
            child: GdsGesture(
              onTap: () {
                // 이미지 뷰어 페이지로 이동
                ImageViewerRoute(initialIndex: 0, imageUrls: [imageUrl]).push(context);
              },
              child: GrimityCachedNetworkImage.fitWidth(imageUrl: imageUrl),
            ),
          );
        }

        return null;
      },
      customStylesBuilder: (e) {
        switch (e.localName) {
          case 'h1':
            return {'font-size': '32px', 'font-weight': '700', 'line-height': '38px', 'margin': '0 0 14px 0'};
          case 'h2':
            return {'font-size': '24px', 'font-weight': '600', 'line-height': '30px', 'margin': '0 0 14px 0'};
          case 'p':
            return {'font-size': '16px', 'font-weight': '500', 'line-height': '24px', 'margin': '0 0 6px 0'};
          case 'a':
            return {'color': AppColor.link.toHexColor(), 'text-decoration': 'none'};
          case 'strong':
          case 'b':
            return {'font-weight': '700'};
          case 'em':
          case 'i':
            return {'font-style': 'italic'};
          case 'u':
            return {'text-decoration': 'underline'};
          case 's':
          case 'del':
            return {'text-decoration': 'line-through'};
          case 'img':
            return {'width': '100%', 'height': 'auto', 'object-fit': 'contain', 'display': 'block'};
        }
        return null;
      },
    );
  }
}

class _PostUserInfoSection extends StatelessWidget {
  const _PostUserInfoSection({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GdsUserInfo.defaultType(
      nickName: post.author?.name ?? '',
      timeText: post.createdAt.toRelativeTime(),
      viewCount: post.viewCount ?? 0,
      showNickName: false,
      showHeart: false,
      showView: true,
      showTime: true,
    );
  }
}
