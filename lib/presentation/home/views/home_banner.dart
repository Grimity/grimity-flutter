import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/post_detail/pages/post_detail_page.dart';

/// 홈 화면에서 기기 유형에 맞는 공지 배너 이미지를 표시하는 위젯.
class HomeBanner extends StatelessWidget {
  const new({super.key});

  static const _smSize = Size(1372, 320);
  static const _lgSize = Size(4380, 360);

  /// 홈 배너를 누르면 이동할 이용 안내 게시글의 아이디.
  static const guidePostId = '048ae290-4b1e-4292-9845-e4b2ca68ea6a';

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GdsGesture(
        onTap: () {
          if (kDebugMode) {
            GdsToast.show('디버그 모드에서는 이용 안내를 열 수 없어요', status: .negative);
            return;
          }

          // 그리미티 이용 규칙에 대한 게시글 페이지로 이동.
          context.push(PostDetailPage(id: guidePostId));
        },
        child: AspectRatio(
          aspectRatio: context.whenDevice(
            mobile: _smSize.aspectRatio,
            tablet: _lgSize.aspectRatio,
          ),
          child: ClipRRect(
            borderRadius: GdsRadius.md.geometry,
            clipBehavior: .hardEdge,
            child: GdsImage(
              provider: context.whenDevice(
                mobile: AssetImage('assets/images/notice_banner_sm.png'),
                tablet: AssetImage('assets/images/notice_banner_lg.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
