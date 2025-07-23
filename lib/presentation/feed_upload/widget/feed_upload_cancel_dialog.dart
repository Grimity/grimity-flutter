import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/widget/grimity_dialog.dart';

void showCancelFeedUploadDialog(BuildContext context, String from) {
  showDialog(
    context: context,
    builder:
        (context) => GrimityDialog(
          title: '업로드를 취소하고 나갈까요?',
          content: '작성한 내용들은 모두 초기화돼요',
          cancelText: '취소',
          confirmText: '나가기',
          onCancel: () => context.pop(),
          onConfirm: () => context.goNamed(from),
        ),
  );
}
