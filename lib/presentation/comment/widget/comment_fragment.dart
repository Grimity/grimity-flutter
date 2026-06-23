import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comment_input_provider.dart';
import 'package:grimity/presentation/comment/provider/comments_data_provider.dart';
import 'package:grimity/presentation/common/hook/layer_link.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/report/report_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentFragment extends HookConsumerWidget {
  const CommentFragment({
    super.key,
    required this.id,
    required this.authorId,
    required this.comment,
    this.parentComment,
    required this.commentType,
  });

  final String id;
  final String authorId;
  final Comment comment;
  final Comment? parentComment;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerLink = useLayerLink();

    if (comment.isAnonymousUserComment) {
      return Padding(
        padding: EdgeInsets.only(left: parentComment != null ? GdsSpacing.spacing32 : 0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: GdsUserItem.commentDeleted(),
        ),
      );
    }

    final isChild = parentComment != null;
    final isAuthor = authorId == comment.writer?.id;
    final isMyComment = comment.writer?.id == ref.watch(userAuthProvider)?.id;
    final isLike = comment.isLike ?? false;
    final commentUserInfo = GdsCommentUserInfo(
      nickName: comment.isDeletedComment ? '탈퇴한 사용자' : comment.writer?.name ?? '',
      onNameTap: comment.isDeletedComment ? null : () => goProfile(context, comment),
      showTag: isAuthor,
      showTime: true,
      timeText: comment.createdAt.toRelativeTime(),
    );

    if (isChild) {
      return GdsUserItem.commentPlusXs(
        personAvatar: GdsPersonAvatar(size: GdsAvatarSize.xs, imageUrl: comment.writer?.image),
        commentUserInfo: commentUserInfo,
        mentionText: getMentionText(comment, parentComment!),
        commentText: comment.content,
        isLiked: isLike,
        onLikeTap: () => toggleLike(ref, comment, !isLike),
        likeCount: comment.likeCount,
        onReplyTap: () => updateCommentReplyState(ref, comment, parentComment),
        onMenuTap: () => showMoreMenu(context, ref, comment, parentComment, isMyComment, layerLink),
        menuLayerLink: layerLink,
      );
    }

    return GdsUserItem.commentXs(
      personAvatar: GdsPersonAvatar(size: GdsAvatarSize.xs, imageUrl: comment.writer?.image),
      commentUserInfo: commentUserInfo,
      commentText: comment.content,
      isLiked: isLike,
      onLikeTap: () => toggleLike(ref, comment, !isLike),
      likeCount: comment.likeCount,
      onReplyTap: () => updateCommentReplyState(ref, comment),
      onMenuTap: () => showMoreMenu(context, ref, comment, null, isMyComment, layerLink),
      menuLayerLink: layerLink,
    );
  }

  String getMentionText(Comment comment, Comment parentComment) {
    final mentionedName = comment.mentionedUser?.name ?? parentComment.writer?.name;
    return mentionedName == null || mentionedName.isEmpty ? '' : '@$mentionedName';
  }

  void goProfile(BuildContext context, Comment comment) {
    final writer = comment.writer;
    if (writer == null) return;

    ProfileRoute(url: writer.url).push(context);
  }

  void toggleLike(WidgetRef ref, Comment comment, bool like) {
    ref.read(commentsDataProvider(commentType, id).notifier).toggleCommentLike(comment.id, like);
  }

  void updateCommentReplyState(WidgetRef ref, Comment comment, [Comment? parentComment]) {
    final writer = comment.writer;
    if (writer == null) return;

    if (parentComment != null) {
      ref
          .read(commentInputProvider(commentType).notifier)
          .updateCommentReplyState(
            parentCommentId: parentComment.id,
            mentionedUserId: writer.id,
            replyUserName: writer.name,
          );
    } else {
      ref
          .read(commentInputProvider(commentType).notifier)
          .updateCommentReplyState(
            parentCommentId: comment.id,
            replyUserName: writer.name,
          );
    }
  }

  Future<void> showMoreMenu(
    BuildContext context,
    WidgetRef ref,
    Comment comment,
    Comment? parentComment,
    bool isMyComment,
    LayerLink layerLink,
  ) {
    late List<GdsMenuItem> items;

    if (isMyComment) {
      items = [
        GdsMenuItem(
          label: '삭제하기',
          onTap: () {
            context.pop();
            ref.read(commentsDataProvider(commentType, id).notifier).deleteComment(comment.id);
          },
        ),
        GdsMenuItem(
          label: '답글달기',
          onTap: () {
            context.pop();
            updateCommentReplyState(ref, comment, parentComment);
          },
        ),
      ];
    } else {
      items = [
        GdsMenuItem(
          label: '신고하기',
          onTap: () {
            context.pop();
            ReportPage.push(context, refId: comment.id, refType: commentType.reportRefType);
          },
        ),
        GdsMenuItem(
          label: '답글달기',
          onTap: () {
            context.pop();
            updateCommentReplyState(ref, comment, parentComment);
          },
        ),
      ];
    }

    final popup = GrimityMenuPopup(layerLink: layerLink, items: items);

    return popup.show(context, GdsMenuPosition.right);
  }
}
