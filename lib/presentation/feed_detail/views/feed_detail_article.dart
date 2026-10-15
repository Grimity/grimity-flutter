import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_actions.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_comments.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_content.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_header.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_images.dart';
import 'package:grimity/widgets/sliver_column.dart';
import 'package:pervice/pervice.dart';

/// 피드의 작성자, 이미지, 본문과 댓글을 표시하는 상세 화면.
class FeedDetailArticle extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.data,
    required this.commentService,
  });

  final String id;
  final FeedDetailResponse data;
  final GetFeedComments commentService;

  @override
  Widget build(BuildContext context) {
    // 현재 사용자가 피드 작성자인지 여부.
    final isAuthor = data.author.id == profile.id;

    // SHARED STATE
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
        // 상세 피드 헤더 표시
        FeedDetailHeader(
          id: data.author.id,
          isAuthor: isAuthor,
          nickname: data.author.name,
          profile: data.author.image?.toImage(),
        ),
        const SliverGap(8),

        // 피드 이미지 목록 표시
        FeedDetailImages(images: data.cards.toImages()),
        const SliverGap(20),

        // 피드 내용 표시
        FeedDetailContent(
          title: data.title,
          content: data.content,
          likeCount: likeCount.value,
          viewCount: viewCount.value,
          createdAt: data.createdAt,
          tags: data.tags,
        ),
        const SliverGap(32),

        // 액션 버튼 표시
        FeedDetailActions(
          id: data.id,
          isAuthor: isAuthor,
          likeCount: likeCount,
          isLike: isLike,
          commentCount: commentCount,
        ),
        const SliverGap(32),

        // 댓글과 대댓글 목록 표시
        FeedDetailComments(
          id: id,
          authorId: data.author.id,
          service: commentService,
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
