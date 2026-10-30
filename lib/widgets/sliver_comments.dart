import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:pervice/pervice.dart';

/// 댓글의 더보기 메뉴를 열 때 호출되는 콜백.
typedef CommentMenuCallback = void Function(
  BuildContext context,
  SliverComment comment,
  LayerLink layerLink,
);

/// 댓글 항목을 표시하는 데 필요한 정보.
class SliverComment({
  required final String id,
  required final String authorId,
  required final String? userId,
  required final String? nickname,
  required final String content,
  required final DateTime createdAt,
  required final int likeCount,
  required final bool isLike,
  required final bool isReply,
  required final bool isDeleted,
  required final String? mention,
  required final ImageProvider? profile,
  required final Future<void> Function(bool) onLike,
  required final CommentMenuCallback onMenu,
  required final VoidCallback onReply,
});

/// 인덱스에 해당하는 댓글 정보를 반환하는 빌더.
typedef SliverCommentBuilder = SliverComment Function(
  BuildContext context,
  int index,
);

/// 댓글과 대댓글을 목록으로 표시하는 슬리버 위젯.
class SliverComments<T extends Service> extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.itemCount,
    required this.itemBuilder,
  });

  final T service;
  final int itemCount;
  final SliverCommentBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        final comment = itemBuilder(context, index + 1);
        final isReply = comment.isReply;

        return Gap(isReply ? 8 : 12);
      },
      itemBuilder: (context, index) {
        final comment = itemBuilder(context, index);

        return _Comment(comment: comment);
      },
    );
  }
}

/// 댓글의 작성자, 본문과 좋아요 및 답글 액션을 표시하는 위젯.
class _Comment extends StatelessWidget {
  const new({required this.comment});

  final SliverComment comment;

  @override
  Widget build(BuildContext context) {
    if (comment.isDeleted) {
      return Padding(
        padding: .only(left: comment.isReply ? 32 : 0),
        child: GdsUserItem.commentDeleted(),
      );
    }

    final isLike = context.stateOf(() => comment.isLike);
    final likeCount = context.stateOf(() => comment.likeCount);
    final layerLink = context.useLayerLink();

    return GdsUserItem.comment(
      size: .xs,
      nickname: comment.nickname!,
      likeCount: likeCount.value,
      isWriter: comment.userId == comment.authorId,
      isReply: comment.isReply,
      isLiked: isLike.value,
      content: comment.content,
      mention: comment.mention,
      profile: comment.profile,
      createdAt: comment.createdAt,
      onReply: comment.onReply,
      onMenu: () => comment.onMenu(context, comment, layerLink),
      onLike: () async {
        final value = !isLike.value;

        try {
          // 요청 전에 좋아요 상태를 화면에 반영.
          isLike.value = value;
          likeCount.value += value ? 1 : -1;

          await comment.onLike(value);
        } catch (_) {
          // 요청 실패 시 좋아요 상태를 복구.
          isLike.value = !value;
          likeCount.value += value ? -1 : 1;

          rethrow;
        }
      },
      layerLink: layerLink,
    );
  }
}
