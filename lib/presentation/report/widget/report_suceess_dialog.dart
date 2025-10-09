import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

void showSuccessReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => GrimityDialog(
          title: '신고가 접수되었어요',
          content: '관리자의 검토 후\n적절한 조치가 이루어질 예정이에요',
          icon: Assets.icons.common.success,
          confirmText: '확인',
          onConfirm: () {
            context.pop();
            context.pop();
          },
        ),
  );
}
