import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 홈 화면에서 기기 유형에 맞는 공지 배너 이미지를 표시하는 위젯.
class HomeBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GdsGesture(
        onTap: () {}, // TODO: 클릭하면 어딘가로 이동해야 함.
        child: AspectRatio(
          aspectRatio: context.whenDevice(
            mobile: 343 / 80,
            tablet: 73 / 6,
          ),
          child: GdsImage(
            provider: context.whenDevice(
              mobile: AssetImage('assets/images/notice_banner_sm.png'),
              tablet: AssetImage('assets/images/notice_banner_lg.png'),
            ),
          ),
        ),
      ),
    );
  }
}
