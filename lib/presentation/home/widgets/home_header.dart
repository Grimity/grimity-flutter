import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 홈 화면의 각 섹션에 제목과 더보기 버튼을 표시하는 위젯.
class HomeHeader extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.onMore,
  });

  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 좌측에 제목 표시
        Expanded(
          child: GdsText(
            title,
            color: .textGrayBold,
            style: context.whenDevice(
              mobile: .title3,
              tablet: .title2,
            ),
          ),
        ),

        // 우측에 더보기 버튼 표시
        GdsButton.text(
          type: .borderless,
          size: .md,
          variant: .assistive,
          label: '더보기',
          onTap: onMore,
        ),
      ],
    );
  }
}
