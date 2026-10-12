import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 홈 화면에서 기기 유형에 맞는 공지 배너 이미지를 표시하는 위젯.
class HomeBanner extends StatelessWidget {
  const new({super.key});

  static const _smSize = Size(1372, 320);
  static const _lgSize = Size(4380, 360);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GdsGesture(
        onTap: () {}, // TODO: 클릭하면 어딘가로 이동해야 함.
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
