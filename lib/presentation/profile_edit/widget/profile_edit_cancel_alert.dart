import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

Future<void> showCancelEditAlert(BuildContext context) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    icon: GdsIcon.success,
    title: '변경 사항을 취소하고 나갈까요?',
    description: '작성한 내용들은 저장되지 않아요',
    primaryLabel: '나가기',
    onPrimaryTap: () {
      context.pop();
      context.pop();
    },
    secondaryLabel: '취소',
    onSecondaryTap: context.pop,
  );

  return alert.open(context);
}
