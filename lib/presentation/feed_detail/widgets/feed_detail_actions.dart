import 'package:flutter/material.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/extensions/model/feed_detail_response_extension.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';
import 'package:pervice/pervice.dart';

/// 피드 상세의 좋아요, 댓글 개수 및 더보기 액션 버튼을 표시하는 위젯.
class FeedDetailActions extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
  });

  final GetFeedsById service;
  final ValueState<int> likeCount;
  final ValueState<int> commentCount;
  final ValueState<bool> isLike;

  @override
  Widget build(BuildContext context) {
    final data = service.data;

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
                  FeedDetailPage.openMenu(
                    context,
                    service,
                    layerLink,
                    share: true,
                    edit: data.isMe,
                    delete: data.isMe,
                    report: !data.isMe,
                    profile: !data.isMe,
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
  void onLike(BuildContext context) {
    final value = !isLike.value;

    AppUseCase.likeFeed(
      context,
      id: service.data.id,
      value: value,
      isLike: isLike,
      likeCount: likeCount,
    );
  }
}
