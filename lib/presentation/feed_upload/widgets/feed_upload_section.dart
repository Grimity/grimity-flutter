import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 피드 작성 항목의 제목과 내용을 표시하는 섹션 위젯.
class FeedUploadSection extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 32,
      children: [
        // 제목 표시
        GdsText(
          title,
          color: .textGrayBold,
          style: .subtitle2,
        ),

        // 본문 표시
        Expanded(child: child),
      ],
    );
  }
}
