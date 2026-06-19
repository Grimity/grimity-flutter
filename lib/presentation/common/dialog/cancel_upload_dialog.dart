import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

Future<T?> showCancelUploadDialog<T>(BuildContext context) {
  final alert = GdsAlert(
    type: GdsAlertType.content,
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '업로드를 취소하고 나가시겠어요?',
    description: '작성한 내용들은 모두 초기화돼요',
    primaryLabel: '나가기',
    onPrimaryTap: () {
      context.pop();
      context.pop();
    },
    secondaryLabel: '아니요',
    onSecondaryTap: context.pop,
  );

  return alert.open<T>(context);
}
