// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/post_detail/views/post_detail_article.dart';
import 'package:grimity/presentation/post_detail/views/post_detail_latest_posts.dart';
import 'package:grimity/presentation/post_detail/widgets/post_detail_input_bar.dart';
import 'package:grimity/presentation/post_upload/pages/post_upload_page.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:grimity/presentation/report/pages/report_page.dart';
import 'package:grimity/views/show_share_modal.dart';
import 'package:grimity/widgets/app_sidebar.dart';
import 'package:grimity/widgets/app_top_navigation.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 글 상세 정보와 댓글, 최신 게시글 목록을 표시하는 페이지.
class PostDetailPage extends StatelessWidget {
  const new({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final detailService = context.serviceOf(
      () => GetPostsById(id: id),
      key: ValueKey(id),
    );

    final commentService = context.serviceOf(
      () => GetPostComments(postId: id),
      key: ValueKey(id),
    );

    return GdsScaffold(
      appBar: AppTopNavigation.title(),
      drawer: const AppSidebar(),
      body: detailService.page(
        loaded: (data) {
          return Column(
            children: [
              Expanded(
                child: SliverScrollView(
                  padding: context.whenDevice(
                    mobile: .only(top: 16, bottom: 56, left: 16, right: 16),
                    tablet: .symmetric(vertical: 24, horizontal: 20),
                  ),
                  spacing: 56,
                  slivers: [
                    // 상세 화면 표시
                    PostDetailArticle(
                      id: id,
                      service: detailService,
                      commentService: commentService,
                    ),

                    // 최신 글 목록 표시
                    PostDetailLatestPosts(),
                  ],
                ),
              ),

              // 댓글 작성 입력창 표시
              PostDetailInputBar(
                id: id,
                service: commentService,
              ),
            ],
          );
        },
      ),
    );
  }

  /// 선택한 항목으로 글 상세의 메뉴를 엽니다.
  static Future<void> openMenu(
    BuildContext context,
    GetPostsById service,
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
            .new(
              label: '공유하기',
              onTap: () {
                context.pop();
                onShare(context, service);
              },
            ),
          ],

          if (profile) ...[
            .new(
              label: '유저 프로필로 이동',
              onTap: () => onProfile(context, service),
            ),
          ],

          if (report) ...[
            .new(
              label: '신고하기',
              onTap: () => onReport(context, service),
            ),
          ],

          if (edit) ...[
            .new(
              label: '수정하기',
              onTap: () => onEdit(context, service),
            ),
          ],

          if (delete) ...[
            .new(
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
    GetPostsById service,
  ) {
    return showShareModal(
      context,
      name: '글',
      text: '이 글 같이 봐요!',
      path: 'posts/${service.data.id}',
    );
  }

  /// 글 작성자의 프로필로 이동할 때 호출됩니다.
  static void onProfile(
    BuildContext context,
    GetPostsById service,
  ) {
    context.pushReplacement(
      ProfilePage(url: service.data.author.url),
    );
  }

  /// 글을 신고할 때 호출됩니다.
  static void onReport(
    BuildContext context,
    GetPostsById service,
  ) {
    final page = ReportPage(
      refId: service.data.id,
      refType: .post,
    );

    page.pushReplacement(context);
  }

  /// 글을 수정할 때 호출됩니다.
  static void onEdit(
    BuildContext context,
    GetPostsById service,
  ) async {
    // 글 업로드 페이지로 이동.
    final isEdited = await context.pushReplacement<bool?, void>(
      PostUploadPage(initialPost: service.data),
    );

    // 글 수정 완료 시 기존 상세 정보 새로고침.
    if (isEdited == true) {
      service.refresh();
    }
  }

  /// 글을 삭제할 때 호출됩니다.
  static void onDelete(
    BuildContext context,
    GetPostsById service,
  ) async {
    final data = service.data;

    // 더보기 메뉴를 닫고 글 삭제 요청.
    context.pop();
    await DeletePostsById(id: data.id).request();

    // 삭제 완료 시 상세 페이지를 닫고 완료 토스트 표시.
    if (context.mounted) {
      context.pop();

      GdsToast.show('${data.title} 글을 삭제했어요', status: .positive);
    }
  }
}
