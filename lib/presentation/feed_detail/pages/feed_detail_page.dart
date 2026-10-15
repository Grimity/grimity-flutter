import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_article.dart';
import 'package:grimity/presentation/feed_detail/views/feed_detail_user.dart';
import 'package:grimity/presentation/feed_detail/widgets/feed_detail_input_bar.dart';
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

          return Column(
            children: [
              Expanded(
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

                    // 작성자 정보
                    FeedDetailUser(
                      authorId: data.author.id,
                      authorName: data.author.name,
                    ),
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
