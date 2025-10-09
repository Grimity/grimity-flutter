import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

void showCancelEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => GrimityDialog(
          title: '변경 사항을 취소하고 나갈까요?',
          content: '작성한 내용들은 저장되지 않아요',
          icon: Assets.icons.common.success,
          cancelText: '취소',
          confirmText: '나가기',
          onCancel: () => context.pop(),
          onConfirm: () => MyRoute().go(context),
        ),
  );
}
