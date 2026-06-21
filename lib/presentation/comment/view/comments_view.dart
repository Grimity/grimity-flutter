import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/comment.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/provider/comments_data_provider.dart';
import 'package:grimity/presentation/comment/widget/comment_fragment.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 댓글 View
class CommentsView extends ConsumerWidget {
  const CommentsView({
    super.key,
    required this.id,
    required this.commentCount,
    required this.authorId,
    required this.commentType,
  });

  final String id;
  final String authorId;
  final int commentCount;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentsDataProvider(commentType, id));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: GdsSpacing.spacing20,
        children: [
          commentsAsync.when(
            data: (comments) {
              return _CommentListView(
                id: id,
                authorId: authorId,
                comments: comments,
                commentType: commentType,
              );
            },
            loading: () {
              return Skeletonizer(
                child: _CommentListView(
                  id: id,
                  authorId: authorId,
                  comments: Comment.emptyList,
                  commentType: commentType,
                ),
              );
            },
            error: (e, s) {
              return GrimityStateView.error(onTap: () => ref.invalidate(commentsDataProvider(commentType, id)));
            },
          ),
          GdsDivider.secondary(size: GdsDividerSize.normal),
        ],
      ),
    );
  }
}

class _CommentListView extends ConsumerWidget {
  const _CommentListView({
    required this.id,
    required this.authorId,
    required this.comments,
    required this.commentType,
  });

  final String id;
  final String authorId;
  final List<Comment> comments;
  final CommentType commentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (comments.isEmpty) {
      return GdsEmptyState(
        size: GdsEmptyStateSize.md,
        icon: GdsIcon.illustReply,
        title: '아직 댓글이 없어요',
        description: '댓글을 써서 생각을 나눠보세요!',
      );
    }

    return Column(
      spacing: GdsSpacing.spacing12,
      children: comments.map((comment) => buildCommentGroup(context, ref, comment)).toList(),
    );
  }

  Widget buildCommentGroup(BuildContext context, WidgetRef ref, Comment parentComment) {
    final childComments = parentComment.childComments ?? [];

    return Column(
      spacing: GdsSpacing.spacing8,
      children: [
        CommentFragment(
          id: id,
          authorId: authorId,
          comment: parentComment,
          commentType: commentType,
        ),

        ...childComments.map((childComment) {
          return CommentFragment(
            id: id,
            authorId: authorId,
            comment: childComment,
            parentComment: parentComment,
            commentType: commentType,
          );
        }),
      ],
    );
  }
}
