import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/widget/grimity_dialog.dart';

void showAlbumMaxCountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => GrimityDialog(
          title: '더 이상 앨범을 추가할 수 없어요',
          content: '앨범은 최대 8개까지 생성할 수 있어요',
          confirmText: '확인',
          onConfirm: () => context.pop(),
        ),
  );
}
