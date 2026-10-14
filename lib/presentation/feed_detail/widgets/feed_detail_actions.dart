import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/bool_extension.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';

/// 피드 상세의 좋아요, 댓글 및 더보기 액션 버튼을 표시하는 위젯.
class FeedDetailActions extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.isAuthor,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
  });

  final String id;
  final bool isAuthor;
  final ValueNotifier<int> likeCount;
  final ValueNotifier<int> commentCount;
  final ValueNotifier<bool> isLike;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            mainAxisSize: .min,
            spacing: 12,
            children: [
              // 좋아요 버튼 표시
              GdsButton.text(
                type: .borderless,
                size: .lg,
                variant: .assistive,
                label: likeCount.value.compact,
                leadingIcon: isLike.value ? .heartFill : .heart,
                iconColor: isLike.value ? .statusNotification : null,
                onTap: () => onLike(context),
              ),

              // 댓글 개수 표시
              GdsButton.text(
                type: .borderless,
                size: .lg,
                variant: .assistive,
                label: commentCount.value.compact,
                leadingIcon: .chatRound,
              ),
            ],
          ),

          // 더보기 버튼 표시
          GdsPopoverAnchor.builder(
            builder: (context, layerLink) {
              return GdsButton.icon(
                type: .normal,
                icon: .dotmenuHorizontal,
                onTap: () {
                  FeedDetailPage.openMoreMenu(
                    context,
                    layerLink,
                    share: true,
                    edit: isAuthor,
                    delete: isAuthor,
                    report: !isAuthor,
                    profile: !isAuthor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// 피드 상세의 좋아요 상태를 변경하고, 실패 시 이전 상태로 복구합니다.
  void onLike(BuildContext context) async {
    final value = !isLike.value;

    try {
      // 요청 전에 좋아요 상태를 화면에 반영.
      isLike.value = value;
      likeCount.value += value ? 1 : -1;

      await value.feedLikeServiceOf(id).request();
    } on DioException catch (_) {
      // 요청 실패 시 이전 상태로 복구.
      isLike.value = !value;
      likeCount.value += value ? -1 : 1;

      if (context.mounted) {
        GdsToast.show(context, '좋아요 변경에 실패했어요.', status: .negative);
      }
    }
  }
}
