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

  /*
  List<Comment> buildTestComments(String authorId) {
    final now = DateTime.now();
    final nickname = User(
      id: 'test-user-nickname',
      name: 'Nickname',
      url: 'test-nickname',
    );
    final strawberry = User(
      id: 'test-user-strawberry',
      name: '스트로베리 필링',
      url: 'test-strawberry',
    );
    final author = User(
      id: authorId,
      name: '체리마루',
      url: 'test-author',
      image: 'https://picsum.photos/seed/cherry-maru/80/80',
    );

    return [
      Comment(
        id: 'test-comment-1',
        content: '오옹 사진 잘 보고 갑니다~',
        createdAt: now.subtract(const Duration(minutes: 32)),
        likeCount: 1,
        isLike: false,
        writer: nickname,
        childComments: [
          Comment(
            id: 'test-comment-1-1',
            content: '감사합니다.',
            createdAt: now.subtract(const Duration(minutes: 32)),
            likeCount: 0,
            isLike: false,
            writer: author,
            mentionedUser: nickname,
          ),
        ],
      ),
      Comment(
        id: 'test-comment-2',
        content: '그림 어디서 참고하셔서 그리셨나요?\n포즈가 너무 좋네요!!',
        createdAt: now.subtract(const Duration(minutes: 32)),
        likeCount: 1,
        isLike: true,
        writer: strawberry,
        childComments: [
          Comment(
            id: 'test-comment-2-1',
            content: '핀터레스트에 포즈 검색하고 거기서 원하는 포즈로 참고했어요!',
            createdAt: now.subtract(const Duration(minutes: 32)),
            likeCount: 2,
            isLike: false,
            writer: author,
            mentionedUser: strawberry,
          ),
          Comment(
            id: 'test-comment-2-2',
            content: '감사합니다 ㅎㅎ',
            createdAt: now.subtract(const Duration(minutes: 32)),
            likeCount: 1,
            isLike: true,
            writer: nickname,
            mentionedUser: author,
          ),
        ],
      ),
      Comment(
        id: 'test-comment-3',
        content: '',
        createdAt: now.subtract(const Duration(minutes: 32)),
        likeCount: 0,
        isLike: false,
        writer: null,
        isDeleted: true,
        childComments: [
          Comment(
            id: 'test-comment-3-1',
            content: '핀터레스트에 포즈 검색하고 거기서 원하는 포즈로 참고했어요!',
            createdAt: now.subtract(const Duration(minutes: 32)),
            likeCount: 2,
            isLike: false,
            writer: author,
            mentionedUser: strawberry,
          ),
          Comment(
            id: 'test-comment-4',
            content: '',
            createdAt: now.subtract(const Duration(minutes: 32)),
            likeCount: 0,
            isLike: false,
            writer: null,
            isDeleted: true,
          ),
        ],
      ),
    ];
  }
  */
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
