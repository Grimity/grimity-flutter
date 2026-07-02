import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/common/hook/layer_link.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_share_popup.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 공통 UtilBar
/// 좋아요, 저장, 댓글, 공유 기능 UtilBar
class GrimityUtilBar extends HookConsumerWidget {
  const GrimityUtilBar({
    super.key,
    required this.isLike,
    required this.isSave,
    required this.likeCount,
    required this.commentCount,
    required this.shareUrl,
    required this.onLikeTap,
    required this.onSaveTap,
    required this.onMoreMenu,
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
  final Function(LayerLink)? onMoreMenu;

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
    Function(LayerLink)? onMoreMenu,
  }) => GrimityUtilBar(
    isLike: isLike,
    isSave: isSave,
    likeCount: likeCount,
    commentCount: commentCount,
    shareUrl: shareUrl,
    onLikeTap: onLikeTap,
    onSaveTap: onSaveTap,
    onMoreMenu: onMoreMenu,
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
    Function(LayerLink)? onMoreMenu,
  }) => GrimityUtilBar(
    isLike: isLike,
    isSave: isSave,
    likeCount: likeCount,
    commentCount: commentCount,
    shareUrl: shareUrl,
    onLikeTap: onLikeTap,
    onSaveTap: onSaveTap,
    onMoreMenu: onMoreMenu,
    shareContentType: ShareContentType.post,
    title: title,
    thumbnail: thumbnail,
    commentType: CommentType.post,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerLink = useLayerLink();
    final colors = context.gdsColors;

    return Row(
      spacing: GdsSpacing.spacing12,
      children: [
        if (commentType == CommentType.feed) ...[
          _buildItem(
            context: context,
            icon: isLike ? GdsIcon.heartFill : GdsIcon.heartOutline,
            text: likeCount.toString(),
            iconColor: isLike ? colors.status.notification : colors.icon.grayBold,
            textColor: colors.text.grayBold,
            onTap: onLikeTap,
          ),
        ] else ...[
          _buildItem(
            context: context,
            icon: isLike ? GdsIcon.bookmarkFill : GdsIcon.bookmarkOutline,
            text: likeCount.toString(),
            iconColor: isLike ? colors.icon.primaryNormal : colors.icon.grayBold,
            textColor: colors.text.grayBold,
            onTap: onLikeTap,
          ),
        ],

        _buildItem(
          context: context,
          icon: GdsIcon.chatRound,
          text: commentCount.toString(),
          iconColor: colors.icon.grayBold,
          textColor: colors.text.grayBold,
        ),

        if (onMoreMenu != null) ...[
          Expanded(child: SizedBox()),
          GdsIconButton(
            icon: GdsIcon.dotMenuHorizontal,
            layerLink: layerLink,
            onPressed: () => onMoreMenu!(layerLink),
          ),
        ],
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required GdsIcon icon,
    required String text,
    required Color iconColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return GdsGesture(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: GdsSpacing.spacing6,
        children: [
          icon.build(color: iconColor),
          Text(text, style: GdsTypography.label3.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
