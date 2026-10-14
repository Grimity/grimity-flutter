import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/feed_detail/pages/feed_detail_page.dart';

/// 피드 작성자의 프로필과 닉네임, 공유 및 더보기 버튼을 표시하는 위젯.
class FeedDetailHeader extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.isAuthor,
    required this.nickname,
    required this.profile,
  });

  final String id;
  final bool isAuthor;
  final String nickname;
  final ImageProvider? profile;

  @override
  Widget build(BuildContext context) {
    final layerLink = context.useLayerLink();

    return SliverToBoxAdapter(
      child: GdsUserItem.iconButton(
        nickname: nickname,
        profile: profile,
        actions: [
          // 공유하기
          .new(icon: .share, onTap: () {}), // TODO
          // 더보기 메뉴
          .new(
            icon: .dotmenuHorizontal,
            layerLink: layerLink,
            onTap: () {
              FeedDetailPage.openMoreMenu(
                context,
                layerLink,
                edit: isAuthor,
                delete: isAuthor,
                report: !isAuthor,
                profile: !isAuthor,
              );
            },
          ),
        ],
        onUser: () {}, // TODO
      ),
    );
  }
}
