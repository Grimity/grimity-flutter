import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

Future<void> showSuccessReportAlert(BuildContext context) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '신고가 접수되었어요',
    description: '관리자의 검토 후\n적절한 조치가 이루어질 예정이에요',
    primaryLabel: '확인',
    onPrimaryTap: () {
      context.pop();
      context.pop();
    },
  );

  return alert.open(context);
}
