import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';

/// 신고가 접수되었음을 안내하는 알림을 표시합니다.
Future<void> showReportCompleteAlert(BuildContext context) {
  return GdsAlert.show(
    context,
    builder: (context) {
      return GdsAlert(
        title: '신고가 접수되었어요',
        description: '관리자의 검토 후\n적절한 조치가 이루어질 예정이예요',
        primaryButton: .new(
          label: '확인',
          onTap: context.pop,
        ),
      );
    },
  );
}
