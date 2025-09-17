import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/config/app_typeface_editor.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_follow_button.dart';
import 'package:grimity/presentation/common/widget/grimity_gray_circle.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_more_button.dart';
import 'package:grimity/presentation/post_detail/widget/post_detail_delete_dialog.dart';
import 'package:grimity/presentation/post_detail/widget/post_util_bar.dart';

class PostContentView extends ConsumerWidget {
  final Post post;

  const PostContentView({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = ref.read(userAuthProvider)?.id == post.author?.id;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostTitleSection(title: post.title),
          Gap(8),
          _PostAuthorInfoSection(
            post: post,
            isMine: isMine,
            onMoreTap: () => _showMoreBottomSheet(context, isMine, ref),
          ),
          Gap(16),
          _PostContentSection(content: post.content),
          Gap(30),
          PostUtilBar(post: post),
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
                  context.push(PostUploadRoute.path, extra: post);
                },
              ),
              GrimityModalButtonModel(
                title: '삭제하기',
                onTap: () {
                  context.pop();
                  showDeletePostDialog(post.id, context, ref);
                },
              ),
            ]
            : [
              GrimityModalButtonModel.report(context: context, refType: ReportRefType.post, refId: post.id),
              GrimityModalButtonModel(
                title: '유저 프로필로 이동',
                onTap: () {
                  context.pop();
                  ProfileRoute(url: post.author!.url).go(context);
                },
              ),
            ];

    GrimityModalBottomSheet.show(context, buttons: buttons);
  }
}

class _PostTitleSection extends StatelessWidget {
  final String title;

  const _PostTitleSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypeface.subTitle1.copyWith(color: AppColor.gray800));
  }
}

class _PostAuthorInfoSection extends StatelessWidget {
  const _PostAuthorInfoSection({required this.post, required this.isMine, required this.onMoreTap});

  final Post post;
  final bool isMine;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // GrimityUserImage(imageUrl: post.author?.image, size: 30),
        // Gap(8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author?.name ?? '작성자 정보 없음',
                style: AppTypeface.label2.copyWith(color: AppColor.gray700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(post.createdAt.toRelativeTime(), style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                  GrimityGrayCircle(),
                  Assets.icons.common.like.svg(width: 16, height: 16),
                  Gap(2),
                  Text('${post.likeCount}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                  GrimityGrayCircle(),
                  Assets.icons.common.view.svg(width: 16, height: 16),
                  Gap(2),
                  Text('${post.viewCount}', style: AppTypeface.caption2.copyWith(color: AppColor.gray600)),
                ],
              ),
            ],
          ),
        ),
        if (!isMine) ...[if (post.author != null) GrimityFollowButton(url: post.author!.url), Gap(10)],
        GrimityMoreButton.decorated(onTap: onMoreTap),
      ],
    );
  }
}

/// Detail의 content는 Html 형식
class _PostContentSection extends StatelessWidget {
  final String content;

  const _PostContentSection({required this.content});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      content,
      textStyle: AppTypefaceEditor.paragraph,
      customWidgetBuilder: (e) {
        /// p태그 하나에 여러개 br이 있는 경우 p태그의 마진이 동작하지 않음
        /// br태그에 p 마진 값 추가
        if (e.localName == 'br') {
          return Gap(6);
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
      onTapImage: (imageMetadata) {
        final imageUrl = imageMetadata.sources.isNotEmpty ? imageMetadata.sources.first.url : null;
        if (imageUrl == null) return;

        ImageViewerRoute(initialIndex: 0, imageUrls: [imageUrl]).push(context);
      },
      // ImageViewerPage
      renderMode: RenderMode.column,
    );
  }
}
