import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/enum/post_type.dart';
import 'package:grimity/extensions/model/post_detail_response.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 글 유형, 제목과 작성자 이름 및 더보기·공유 버튼을 표시하는 위젯.
class PostDetailHeader extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  /// 글 상세 정보를 조회하고 갱신하는 서비스.
  final GetPostsById service;

  @override
  Widget build(BuildContext context) {
    final data = service.data;

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: .end,
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                // 글 유형 표시
                GdsChip(
                  variant: data.type == .notice ? .primary : .assistive,
                  size: context.whenDevice(
                    mobile: .md,
                    tablet: .xl,
                  ),
                  label: data.type.displayName,
                ),
                const Gap(12),

                // 글 제목 표시
                GdsText(
                  data.title,
                  color: .textGrayBold,
                  style: context.whenDevice(
                    mobile: .title2,
                    tablet: .title3,
                  ),
                ),
                const Gap(8),

                // 작성자 이름 표시
                GdsText(
                  data.author.name,
                  color: .textGraySubtle,
                  style: .label6,
                ),
              ],
            ),
          ),

          // 액션 버튼 표시
          Row(
            mainAxisSize: .min,
            spacing: 4,
            children: [
              // 더보기 메뉴
              GdsPopoverAnchor.builder(
                builder: (context, layerLink) {
                  return GdsButton.icon(
                    type: .sm,
                    icon: .dotmenuHorizontal,
                    onTap: () {
                      PostDetailPage.openMenu(
                        context,
                        service,
                        layerLink,
                        edit: data.isMine,
                        delete: data.isMine,
                        report: !data.isMine,
                        profile: !data.isMine,
                      );
                    },
                  );
                },
              ),

              // 공유 버튼 표시
              GdsButton.icon(
                type: .sm,
                icon: .share,
                onTap: () {
                  PostDetailPage.onShare(context, service);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
