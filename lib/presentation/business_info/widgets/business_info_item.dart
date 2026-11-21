import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 사업자 정보의 항목 이름과 값을 표시하는 위젯.
class BusinessInfoItem extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        GdsText(
          label,
          color: .textGrayBold,
          style: .subtitle2,
        ),

        GdsText(
          value,
          color: .textGrayBold,
          style: .body2R,
        ),
      ],
    );
  }
}
