import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_article.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_latest_feeds.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_author.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_input_bar.dart';
import 'package:grimity/presentation/feed_upload/pages/feed_upload_page.dart';
import 'package:grimity/widgets/app_sidebar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 피드 상세 정보와 댓글, 작성자 정보와 이후 최신 그림을 표시하는 페이지.
class FeedDetailPage extends StatelessWidget {
  const new({super.key, required this.id});

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

    final latestFeedsService = context.serviceOf(
      FeedDetailLatestFeeds.createService,
      key: ValueKey(id),
    );

    return GdsScaffold(
      appBar: AppTopNavigation.title(),
      drawer: const AppSidebar(),
      body: detailService.when(
        loading: () {
          return Center(
            child: GdsCircularLoading(),
          );
        },
        loaded: (data) {
          // 차단된 작성자의 피드인 경우.
          if (data.author.isBlocked) {
            GdsToast.show('차단된 계정이에요', status: .negative);
          }

          return Column(
            children: [
              Expanded(
                child: GdsInfiniteScroll(
                  onLoadMore: latestFeedsService.loadMore,
                  enabled: latestFeedsService.canLoreMore,
                  child: SliverScrollView(
                    padding: context.whenDevice(
                      mobile: .only(top: 8, bottom: 16, left: 16, right: 16),
                      tablet: .only(top: 24, bottom: 20, left: 20, right: 20),
                    ),
                    spacing: 56,
                    slivers: [
                      // 상세 화면 표시
                      FeedDetailArticle(
                        id: id,
                        data: data,
                        commentService: commentService,
                      ),

                      // 작성자 피드 표시
                      FeedDetailAuthor(
                        authorId: data.author.id,
                        authorName: data.author.name,
                      ),

                      // 최신 그림 표시
                      FeedDetailLatestFeeds(
                        service: latestFeedsService,
                      ),
                    ],
                  ),
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
    FeedDetailResponse data,
    LayerLink layerLink, {
    bool share = false,
    bool report = false,
    bool profile = false,
    bool delete = false,
    bool edit = false,
  }) async {
    return GdsAdaptiveMenu.show<void>(
      context,
      layerLink: layerLink,
      position: .right,
      builder: (context) => GdsAdaptiveMenu(
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
            (
              label: '수정하기',
              onTap: () => onEdit(context, data),
            ),
          ],

          if (delete) ...[
            (
              label: '삭제하기',
              onTap: () => onDelete(context, data),
            ),
          ],
        ],
      ),
    );
  }

  /// 피드를 수정할 때 호출됩니다.
  static void onEdit(
    BuildContext context,
    FeedDetailResponse data,
  ) {
    // 피드 업로드 페이지로 이동.
    context.pushReplacement(FeedUploadPage(initialFeed: data));
  }

  /// 피드를 삭제할 때 호출됩니다.
  static void onDelete(
    BuildContext context,
    FeedDetailResponse data,
  ) async {
    context.pop();
    await DeleteFeedsById(id: data.id).request();

    // 삭제 완료 시 상세 페이지를 닫고 완료 토스트 표시.
    if (context.mounted) {
      context.pop();

      GdsToast.show('${data.title} 피드를 삭제했어요', status: .positive);
    }
  }
}
