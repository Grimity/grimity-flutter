import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/view/comments_view.dart';
import 'package:grimity/presentation/comment/widget/comment_input_bar.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/feed_detail/feed_detail_view.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:grimity/presentation/feed_detail/view/feed_author_profile_view.dart';
import 'package:grimity/presentation/feed_detail/view/feed_content_view.dart';
import 'package:grimity/presentation/feed_detail/view/feed_recommend_feed_view.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_detail_app_bar.dart';
import 'package:grimity/presentation/feed_detail/widget/feed_util_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 피드 상세 페이지
class FeedDetailPage extends ConsumerWidget {
  final String feedId;

  const FeedDetailPage({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedDetailDataProvider(feedId));

    return feedAsync.when(
      data: (feed) {
        feed ??= Feed.empty();
        return FeedDetailView(
          feed: feed,
          feedDetailAppBar: FeedDetailAppBar(),
          feedContentView: FeedContentView(feed: feed),
          feedCommentsView: CommentsView(
            id: feed.id,
            authorId: feed.author?.id ?? '',
            commentCount: feed.commentCount ?? 0,
            commentType: CommentType.feed,
          ),
          feedAuthorProfileView: FeedAuthorProfileView(author: feed.author ?? User.empty()),
          feedRecommendFeedView: FeedRecommendFeedView(),
          feedCommentInputBar: CommentInputBar(id: feed.id, commentType: CommentType.feed),
          feedUtilBar: FeedUtilBar(feed: feed),
        );
      },
      loading: () {
        final feed = Feed.empty();

        return Skeletonizer(
          child: FeedDetailView(
            feed: feed,
            feedDetailAppBar: FeedDetailAppBar(),
            feedContentView: FeedContentView(feed: feed),
            feedCommentsView: CommentsView(
              id: feed.id,
              authorId: feed.author?.id ?? '',
              commentCount: feed.commentCount ?? 0,
              commentType: CommentType.feed,
            ),
            feedAuthorProfileView: FeedAuthorProfileView(author: feed.author ?? User.empty()),
            feedRecommendFeedView: FeedRecommendFeedView(),
            feedCommentInputBar: CommentInputBar(id: feed.id, commentType: CommentType.feed),
            feedUtilBar: FeedUtilBar(feed: feed),
          ),
        );
      },
      error:
          (e, s) => Scaffold(
            appBar: AppBar(),
            body: GrimityStateView.error(onTap: () => ref.invalidate(feedDetailDataProvider(feedId))),
          ),
    );
  }
}
