import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/post_detail/views/post_detail_comments.dart';
import 'package:grimity/presentation/post_detail/widgets/post_detail_actions.dart';
import 'package:grimity/presentation/post_detail/widgets/post_detail_content.dart';
import 'package:grimity/presentation/post_detail/widgets/post_detail_header.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:pervice/pervice.dart';

/// 글의 정보, 본문과 댓글을 표시하는 상세 화면.
class PostDetailArticle extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.service,
    required this.commentService,
  });

  final String id;
  final GetPostsById service;
  final GetPostComments commentService;

  @override
  Widget build(BuildContext context) {
    final data = service.data;

    // 본문과 액션 버튼에서 좋아요 여부 및 각 항목의 개수 공유.
    final isLike = context.sharedStateOf(
      () => data.isLike,
      key: ValueKey('feed-${data.id}:is-like'),
    );

    final likeCount = context.sharedStateOf(
      () => data.likeCount.toInt(),
      key: ValueKey('feed-${data.id}:like-count'),
    );

    final viewCount = context.sharedStateOf(
      () => data.viewCount.toInt(),
      key: ValueKey('feed-${data.id}:view-count'),
    );

    final commentCount = context.sharedStateOf(
      () => data.commentCount.toInt(),
      key: ValueKey('feed-${data.id}:comment-count'),
    );

    return SliverColumn(
      children: [
        // 글 헤더 표시
        PostDetailHeader(service: service),
        const SliverGap(20),

        // 글 내용 표시
        PostDetailContent(
          data: data,
          viewCount: viewCount.value,
        ),
        const SliverGap(32),

        // 액션 버튼 표시
        PostDetailActions(
          service: service,
          likeCount: likeCount,
          commentCount: commentCount,
          isLike: isLike,
        ),
        const SliverGap(32),

        // 댓글과 대댓글 목록 표시
        PostDetailComments(
          id: id,
          authorId: data.author.id,
          commentService: commentService,
        ),
        const SliverGap(20),

        // 구분선 표시
        SliverToBoxAdapter(
          child: GdsDivider(variant: .secondary),
        ),
      ],
    );
  }
}
