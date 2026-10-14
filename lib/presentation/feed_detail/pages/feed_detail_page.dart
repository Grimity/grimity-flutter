import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_actions.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_content.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_comments.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_header.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_images.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_input_bar.dart';
import 'package:grimity/widgets/app_sidebar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 피드 상세 정보와 댓글, 작성자 정보와 이후 최신 그림을 표시하는 페이지.
class FeedDetailPage extends StatelessWidget {
  const new({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final detailService = context.serviceOf(
      () => GetFeedsById(id: id),
      key: ValueKey(id),
    );

    final commentService = context.serviceOf(
      () => GetFeedComments(feedId: id),
      key: ValueKey(id),
    );

    return GdsScaffold(
      appBar: AppTopNavigation.title(),
      drawer: const AppSidebar(),
      body: detailService.when(
        loading: () {
          return Center(child: GdsCircularLoading());
        },
        loaded: (data) {
          // 차단된 작성자의 피드인 경우.
          if (data.author.isBlocked) {
            GdsToast.show(context, '차단된 계정이에요', status: .negative);
          }

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

          return Column(
            children: [
              Expanded(
                child: SliverScrollView(
                  padding: context.whenDevice(
                    mobile: .only(top: 8, bottom: 16, left: 16, right: 16),
                    tablet: .only(top: 24, bottom: 20, left: 20, right: 20),
                  ),
                  slivers: [
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
                    const SliverGap(56),
                  ],
                ),
              ),

              // 댓글 작성 입력창 표시
              FeedDetailInputBar(
                id: id,
                service: commentService,
              ),
            ],
          );
        },
      ),
    );
  }

  /// 선택한 항목으로 피드 상세 메뉴를 엽니다.
  static Future<void> openMoreMenu(
    BuildContext context,
    LayerLink layerLink, {
    bool share = false,
    bool report = false,
    bool profile = false,
    bool delete = false,
    bool edit = false,
  }) async {
    final menu = GdsAdaptiveMenu(
      layerLink: layerLink,
      position: .right,
      items: [
        if (share) ...[
          (label: '공유하기', onTap: () {}),
        ],

        if (profile) ...[
          (label: '유저 프로필로 이동', onTap: () {}),
        ],

        if (report) ...[
          (label: '신고하기', onTap: () {}), // TODO
        ],

        if (edit) ...[
          (label: '수정하기', onTap: () {}), // TODO
        ],

        if (delete) ...[
          (label: '삭제하기', onTap: () {}), // TODO
        ],
      ],
    );

    return menu.open(context);
  }
}
