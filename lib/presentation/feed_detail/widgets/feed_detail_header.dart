import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/model/feed_detail_response_extension.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';

/// 피드 작성자의 프로필과 닉네임, 공유 및 더보기 버튼을 표시하는 위젯.
class FeedDetailHeader extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final GetFeedsById service;

  @override
  Widget build(BuildContext context) {
    final layerLink = context.useLayerLink();
    final data = service.data;

    return SliverToBoxAdapter(
      child: GdsUserItem.iconButton(
        nickname: data.author.name,
        profile: data.author.image?.toImage(),
        actions: [
          // 공유하기
          .new(
            icon: .share,
            onTap: () {
              FeedDetailPage.onShare(context, service);
            },
          ),

          // 더보기 메뉴
          .new(
            icon: .dotmenuHorizontal,
            layerLink: layerLink,
            onTap: () {
              FeedDetailPage.openMenu(
                context,
                service,
                layerLink,
                edit: data.isMine,
                delete: data.isMine,
                report: !data.isMine,
                profile: !data.isMine,
              );
            },
          ),
        ],
        onUser: () {}, // TODO
      ),
    );
  }
}
