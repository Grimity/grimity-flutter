import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:pervice/pervice.dart';

/// 피드 작성자의 프로필과 관련된 피드 목록을 표시하는 화면.
class FeedDetailAuthor extends StatelessWidget {
  const new({
    super.key,
    required this.authorId,
    required this.authorName,
  });

  final String authorId;
  final String authorName;

  /// 작성자 프로필을 불러오는 동안 표시할 임시 데이터.
  static const userPlaceholder = UserProfileResponse(
    id: '',
    name: 'Placeholder',
    image: '',
    url: '',
    isBlocked: false,
    description: '',
    links: [],
    followerCount: 0,
    followingCount: 0,
    feedCount: 0,
    postCount: 0,
    isFollowing: false,
    isBlocking: false,
    albums: [],
  );

  /// 작성자의 피드를 불러오는 동안 표시할 임시 피드 데이터.
  static final feedPlaceholder = UserFeedsResponse(
    feeds: List.generate(10, (index) {
      return .new(
        id: '',
        title: 'Placeholder',
        thumbnail: '',
        likeCount: 0,
        viewCount: 0,
        cards: [],
        createdAt: .now(),
        commentCount: 0,
        isLike: false,
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    final userService = context.serviceOf(() => GetUsersById(id: authorId));
    final feedService = context.serviceOf(() => GetUsersByIdFeeds(id: authorId));

    return SliverToBoxAdapter(
      child: Column(
        spacing: 12,
        children: [
          // 작성자 프로필과 팔로우 버튼 표시
          userService.builder(
            placeholder: userPlaceholder,
            builder: (data) {
              // SHARED STATE
              final followerCount = context.sharedStateOf(
                () => data.followerCount.toInt(),
                key: ValueKey('feed-${data.id}:follower-count'),
              );

              final isFollowing = context.sharedStateOf(
                () => data.isFollowing,
                key: ValueKey('feed-${data.id}:is-following'),
              );

              return GdsUserItem.follow(
                followerCount: followerCount.value,
                followingCount: data.followingCount.toInt(),
                nickname: data.name,
                profile: data.image?.toImage(),
                actions: [
                  .new(
                    label: '작품 보기',
                    onTap: () {}, // TODO
                    type: .outlined,
                  ),

                  // 팔로우 버튼 표시
                  .follow(
                    following: isFollowing.value,
                    onFollow: () {
                      AppUseCase.follow(
                        context,
                        id: authorId,
                        isFollowing: isFollowing,
                        followerCount: followerCount,
                      );
                    },
                    onUnFollow: () {
                      AppUseCase.unFollow(
                        context,
                        id: authorId,
                        isFollowing: isFollowing,
                        followerCount: followerCount,
                      );
                    },
                  ),
                ],
              );
            },
          ),

          // 작성자의 다른 작품 목록 표시
          feedService.builder(
            placeholder: feedPlaceholder,
            builder: (data) {
              final feeds = data.feeds;

              // 극히 예외적으로 작성자의 피드가 아예 없는 경우.
              if (feeds.isEmpty) {
                return SizedBox.shrink();
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // 작품 카드의 너비를 피드 그리드의 열 개수와 간격에 맞춤.
                  final maxWidth = constraints.maxWidth;
                  final spacing = 16.0;
                  final count = context.feedGridCrossAxisCount;
                  final width = (maxWidth - spacing * (count - 1)) / count;

                  return HorizontalListView.separated(
                    itemCount: feeds.length,
                    separatorBuilder: (context, index) => Gap(spacing),
                    clipBehavior: .none,

                    // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
                    cacheExtent: 0,
                    itemBuilder: (context, index) {
                      final feed = feeds[index];

                      return SizedBox(
                        width: width,
                        child: buildFeed(context, feed),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// 작성자의 각 작품을 좋아요 상태와 함께 앨범 카드로 표시합니다.
  Widget buildFeed(BuildContext context, UserFeedResponse feed) {
    final isLike = context.sharedStateOf(
      () => feed.isLike,
      key: ValueKey('feed-${feed.id}:is-like'),
    );

    final likeCount = context.sharedStateOf(
      () => feed.likeCount.toInt(),
      key: ValueKey('feed-${feed.id}:like-count'),
    );

    final viewCount = context.sharedStateOf(
      () => feed.viewCount.toInt(),
      key: ValueKey('feed-${feed.id}:view-count'),
    );

    return GdsAlbum(
      image: feed.thumbnail.toImage(),
      title: feed.title,
      nickname: authorName,
      likeCount: likeCount.value,
      viewCount: viewCount.value,
      like: isLike.value,
      onTap: () {
        // 피드 상세 페이지로 이동.
        context.push(FeedDetailPage(id: feed.id));
      },
      onLike: (value) {
        AppUseCase.likeFeed(
          context,
          id: feed.id,
          value: value,
          isLike: isLike,
          likeCount: likeCount,
        );
      },
    );
  }
}
