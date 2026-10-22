import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_use_case.dart';
import 'package:grimity/extensions/model/post_detail_response_extension.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';
import 'package:pervice/pervice.dart';

/// 글 상세의 좋아요, 댓글 개수 및 더보기 액션 버튼을 표시하는 위젯.
class PostDetailActions extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
  });

  /// 글 상세 정보를 조회하고 갱신하는 서비스.
  final GetPostsById service;

  /// 좋아요 버튼과 본문 영역에서 공유하는 좋아요 수.
  final ValueState<int> likeCount;

  /// 화면에 표시할 댓글 수의 공유 상태.
  final ValueState<int> commentCount;

  /// 현재 사용자의 좋아요 여부에 대한 공유 상태.
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
                  PostDetailPage.openMenu(
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

  /// 글 상세의 좋아요 상태를 변경하고, 실패 시 이전 상태로 복구합니다.
  void onLike(BuildContext context) {
    final value = !isLike.value;

    AppUseCase.likePost(
      context,
      id: service.data.id,
      value: value,
      isLike: isLike,
      likeCount: likeCount,
    );
  }
}
