import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/comment/enum/comment_type.dart';
import 'package:grimity/presentation/comment/view/comments_view.dart';
import 'package:grimity/presentation/comment/widget/comment_input_bar.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';
import 'package:grimity/presentation/feed_detail/feed_detail_view.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:grimity/presentation/feed_detail/view/feed_author_profile_view.dart';
import 'package:grimity/presentation/feed_detail/view/feed_content_view.dart';
import 'package:grimity/presentation/feed_detail/view/feed_recommend_feed_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 피드 상세 페이지
class FeedDetailPage extends HookConsumerWidget {
  final String feedId;

  const FeedDetailPage({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBlockedToast = useState(false);
    final feedAsync = ref.watch(feedDetailDataProvider(feedId));

    return feedAsync.when(
      data: (feed) {
        feed ??= Feed.empty();
        final isBlockedUser = feed.author?.isBlocked == true;

        if (isBlockedUser && !showBlockedToast.value) {
          showBlockedToast.value = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastService.showFailure('차단당한 계정입니다.');
          });
        }

        return FeedDetailView(
          feed: feed,
          feedDetailAppBar: GrimityTitleTopNavigation(title: '', showTitle: false),
          feedContentView: FeedContentView(feed: feed),
          feedCommentsView:
              isBlockedUser
                  ? null
                  : CommentsView(
                    id: feed.id,
                    authorId: feed.author?.id ?? '',
                    commentType: CommentType.feed,
                    commentCount: feed.commentCount ?? 0,
                  ),
          feedAuthorProfileView: FeedAuthorProfileView(author: feed.author ?? User.empty()),
          feedRecommendFeedView: FeedRecommendFeedView(),
          feedCommentInputBar: isBlockedUser ? null : CommentInputBar(id: feed.id, commentType: CommentType.feed),
        );
      },
      loading: () {
        final feed = Feed.empty();

        return Skeletonizer(
          child: FeedDetailView(
            feed: feed,
            feedDetailAppBar: GrimityTitleTopNavigation(title: '', showTitle: false),
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
          ),
        );
      },
      error: (_, _) {
        return Scaffold(
          appBar: AppBar(),
          body: GrimityStateView.error(onTap: () => ref.invalidate(feedDetailDataProvider(feedId))),
        );
      },
    );
  }
}
