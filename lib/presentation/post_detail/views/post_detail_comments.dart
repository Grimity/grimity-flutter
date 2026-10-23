import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/post_detail/widgets/post_detail_input_bar.dart';
import 'package:grimity/widgets/sliver_comment_list.dart';
import 'package:pervice/pervice.dart';

/// 글의 댓글과 대댓글을 작성 순서대로 표시하는 위젯.
class PostDetailComments extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.authorId,
    required this.commentService,
  });

  final String id;
  final String authorId;
  final GetPostComments commentService;

  /// 댓글 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = List.generate(
    3,
    (index) => ParentPostCommentResponse(
      id: 'placeholder-$index',
      content: 'Placeholder',
      createdAt: .now(),
      likeCount: 0,
      writer: .new(id: '_', name: 'Placeholder', url: ''),
      childComments: [],
      isLike: false,
      isDeleted: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final comments = commentService.maybeData ?? placeholder;

    // SHARED STATE
    final mention = context.sharedStateOf<PostMention?>(
      () => null,
      key: ValueKey('post-$id:mention'),
    );

    final focusNode = context.sharedStateOf(
      FocusNode.new,
      key: ValueKey('post-$id:focus-node'),
    );

    // 보여줄 댓글이 아예 없는 경우.
    if (comments.isEmpty) {
      return SliverToBoxAdapter(
        child: GdsEmptyState(
          illust: .illustReply,
          title: '아직 댓글이 없어요',
          description: '댓글을 써서 생각을 나눠보세요!',
        ),
      );
    }

    // API 응답을 공통 댓글 항목으로 변환.
    final items = <SliverComment>[
      // 본문 댓글 목록
      for (final parent in comments) ...[
        .new(
          id: parent.id,
          authorId: authorId,
          userId: parent.writer?.id,
          nickname: parent.writer?.name,
          content: parent.content,
          createdAt: parent.createdAt,
          likeCount: parent.likeCount.toInt(),
          isLike: parent.isLike,
          isReply: false,
          isDeleted: parent.isDeleted,
          mention: null,
          profile: parent.writer?.image?.toImage(),
          onReply: () {
            mention.value = (
              userName: parent.writer!.name,
              userId: parent.writer!.id,
              parentCommentId: parent.id,
            );

            focusNode.value.requestFocus();
          },
          onMenu: openMenu,
          onLike: (value) => onLike(parent.id, value),
        ),

        // 하위 댓글 목록
        for (final reply in parent.childComments)
          .new(
            id: reply.id,
            authorId: authorId,
            userId: reply.writer?.id,
            nickname: reply.writer?.name,
            content: reply.content,
            createdAt: reply.createdAt,
            likeCount: reply.likeCount.toInt(),
            isLike: reply.isLike,
            isReply: true,
            isDeleted: parent.isDeleted,
            mention: reply.mentionedUser?.name ?? parent.writer?.name,
            profile: reply.writer?.image?.toImage(),
            onReply: () {
              mention.value = (
                userName: reply.writer!.name,
                userId: reply.writer!.id,
                parentCommentId: parent.id,
              );

              focusNode.value.requestFocus();
            },
            onMenu: openMenu,
            onLike: (value) => onLike(reply.id, value),
          ),
      ],
    ];

    return SliverCommentList(
      service: commentService,
      itemCount: items.length,
      itemBuilder: (_, index) => items[index],
    );
  }

  /// 댓글의 좋아요 상태를 서버에 반영합니다.
  Future<void> onLike(String commentId, bool value) async {
    if (value) {
      await PutPostCommentsByIdLike(id: commentId).request();
    } else {
      await DeletePostCommentsByIdLike(id: commentId).request();
    }
  }

  /// 선택한 항목으로 댓글 메뉴를 엽니다.
  Future<void> openMenu(
    BuildContext context,
    SliverComment comment,
    LayerLink layerLink,
  ) async {
    final isMine = comment.userId == profile.id;

    return GdsAdaptiveMenu.show<void>(
      context,
      layerLink: layerLink,
      position: .right,
      builder: (context) => GdsAdaptiveMenu(
        items: [
          // 본인이 작성한 댓글인 경우
          if (isMine) ...[
            (
              label: '삭제하기',
              onTap: () {
                context.pop();
                onDelete(comment);
              },
            ),
          ],

          // 타인이 작성한 댓글의 경우
          if (!isMine) ...[
            (
              label: '답글달기',
              onTap: () {
                context.pop();
                comment.onReply();
              },
            ),
            (
              label: '신고하기',
              onTap: () {}, // TODO
            ),
          ],
        ],
      ),
    );
  }

  /// 댓글을 삭제할 때 호출됩니다.
  void onDelete(SliverComment comment) async {
    await DeletePostCommentsById(id: comment.id).request();

    // 삭제 후 댓글 목록을 새로고침하고 완료 안내 표시.
    commentService.refresh();
    GdsToast.show('댓글을 삭제했어요', status: .positive);
  }
}
