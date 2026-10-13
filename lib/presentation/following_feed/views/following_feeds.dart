import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/following_feed/widgets/following_feed_carousel.dart';
import 'package:grimity/presentation/following_feed/widgets/following_feed_comment.dart';
import 'package:grimity/presentation/navigation/navigation_page.dart';

/// 팔로우한 작가의 피드를 이미지, 본문과 댓글을 포함하여 이를 목록으로 표시하는 위젯.
class FollowingFeeds extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final LoadMoreService<FollowingFeedsResponse> service;

  /// 팔로잉 피드를 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    FollowingFeedsResponse(
      feeds: List.generate(10, (_) {
        return .new(
          id: '',
          title: 'Placeholder',
          thumbnail: '',
          likeCount: 0,
          viewCount: 0,
          author: .new(id: '', name: 'Placeholder', url: ''),
          isLike: false,
          cards: [''],
          tags: [],
          isSave: false,
          content: 'Placeholder',
          commentCount: 0,
          comment: null,
          createdAt: .now(),
        );
      }),
    ),
  ];

  /// 커서를 이용해 팔로잉 피드를 추가로 조회하는 서비스를 생성합니다.
  static LoadMoreService<FollowingFeedsResponse> createService() {
    return .new(
      builder: (cursor) => GetFeedsFollowing(cursor: cursor),
      cursorOf: (data) => data.nextCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = service.maybeData ?? placeholder;
    final feeds = data.expand((e) => e.feeds).toList();

    // 보여줄 수 있는 피드가 아예 없을 경우.
    if (feeds.isEmpty) {
      return SliverToBoxAdapter(
        child: GdsEmptyState(
          illust: .uploadSuccess,
          title: '팔로우한 작가가 없어요',
          description: '관심 있는 작가를 팔로우하고\n새로운 작품 소식을 받아보세요',
          button: .new(
            label: '인기 그림 보러가기',
            onTap: () {
              // 랭킹 페이지로 이동.
              NavigationPage.moveTo(context, 1);
            },
          ),
        ),
      );
    }

    return SliverList.separated(
      separatorBuilder: (_, _) => 24.verticalGap,
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        final feed = feeds[index];

        return service.build(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              // 작가 프로필 표시
              GdsUserItem.iconButton(
                nickname: feed.author.name,
                profile: feed.author.image?.responsiveImage,
                actions: [
                  .new(
                    icon: .dotmenuHorizontal,
                    onTap: () {}, // TODO
                  ),
                ],
                onUser: () {}, // TODO
              ),
              8.verticalGap,

              // 제목 표시
              GdsText(
                feed.title,
                color: .textGrayBold,
                style: context.whenDevice(
                  mobile: .title3,
                  tablet: .title2,
                ),
              ),
              12.verticalGap,

              // 본문 표시
              GdsExpandableText(
                feed.content,
                color: .textGrayBold,
                style: .body1R,
                maxLines: 3,
              ),
              20.verticalGap,

              // 이미지 표시
              FollowingFeedCarousel(
                onTap: (value) {}, // TODO
                images: feed.cards.map((e) => e.responsiveImage).toList(),
              ),
              12.verticalGap,

              Row(
                spacing: 8,
                children: [
                  // 좋아요 버튼 표시
                  GdsButton.text(
                    type: .borderless,
                    size: .lg,
                    variant: .assistive,
                    label: feed.likeCount.compact,
                    leadingIcon: feed.isLike ? .heartFill : .heart,
                    iconColor: feed.isLike ? .statusNotification : null,
                    onTap: () {}, // TODO
                  ),

                  // 댓글 개수 표시
                  GdsButton.text(
                    type: .borderless,
                    size: .lg,
                    variant: .assistive,
                    label: feed.commentCount.compact,
                    leadingIcon: .chatRound,
                  ),
                ],
              ),

              // 주요 댓글 표시
              if (feed.comment != null) ...[
                12.verticalGap,

                FollowingFeedComment(
                  onTap: () {}, // TODO
                  profile: feed.comment!.writer.image?.responsiveImage,
                  content: feed.comment!.content,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
