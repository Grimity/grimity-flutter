import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showConfirmReportAlert(BuildContext context) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '신고하시겠어요?',
    description: '신고 접수 후에는 취소가 어려워요.\n허위 신고 시 서비스 이용이 제한될 수 있어요.',
    primaryLabel: '신고하기',
    onPrimaryTap: () => context.pop(true),
    secondaryLabel: '아니요',
    onSecondaryTap: () => context.pop(false),
  );

  return alert.open<bool?>(context);
}
