import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_article.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_latest_feeds.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_author.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_input_bar.dart';
import 'package:grimity/presentation/feed_upload/pages/feed_upload_page.dart';
import 'package:grimity/presentation/report/pages/report_page.dart';
import 'package:grimity/views/show_share_modal.dart';
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
      body: detailService.page(
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
                        service: detailService,
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

  /// 선택한 항목으로 피드 상세의 메뉴를 엽니다.
  static Future<void> openMenu(
    BuildContext context,
    GetFeedsById service,
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
            (
              label: '공유하기',
              onTap: () {
                context.pop();
                onShare(context, service);
              },
            ),
          ],

          if (profile) ...[
            (label: '유저 프로필로 이동', onTap: () {}),
          ],

          if (report) ...[
            (
              label: '신고하기',
              onTap: () => onReport(context, service),
            ),
          ],

          if (edit) ...[
            (
              label: '수정하기',
              onTap: () => onEdit(context, service),
            ),
          ],

          if (delete) ...[
            (
              label: '삭제하기',
              onTap: () => onDelete(context, service),
            ),
          ],
        ],
      ),
    );
  }

  /// 공유 방법을 선택하는 모달을 엽니다.
  static Future<void> onShare(
    BuildContext context,
    GetFeedsById service,
  ) {
    return showShareModal(
      context,
      name: '그림',
      text: '이 그림 어때요?',
      path: 'feeds/${service.data.id}',
    );
  }

  /// 피드를 신고할 때 호출됩니다.
  static void onReport(
    BuildContext context,
    GetFeedsById service,
  ) {
    final page = ReportPage(
      refId: service.data.id,
      refType: .feed,
    );

    page.pushReplacement(context);
  }

  /// 피드를 수정할 때 호출됩니다.
  static void onEdit(
    BuildContext context,
    GetFeedsById service,
  ) async {
    // 피드 업로드 페이지로 이동.
    final isEdited = await context.pushReplacement<bool?, void>(
      FeedUploadPage(initialFeed: service.data),
    );

    // 피드 수정을 완료했을 경우.
    if (isEdited == true) {
      service.refresh();
    }
  }

  /// 피드를 삭제할 때 호출됩니다.
  static void onDelete(
    BuildContext context,
    GetFeedsById service,
  ) async {
    final data = service.data;
    context.pop();
    await DeleteFeedsById(id: data.id).request();

    // 삭제 완료 시 상세 페이지를 닫고 완료 토스트 표시.
    if (context.mounted) {
      context.pop();

      GdsToast.show('${data.title} 피드를 삭제했어요', status: .positive);
    }
  }
}
