import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_dialog.dart';

void showAlbumDeleteDialog(BuildContext context, WidgetRef ref, Album album) {
  showDialog(
    context: context,
    builder:
        (context) => GrimityDialog(
          title: '앨범을 삭제할까요?',
          content: '앨범을 삭제하면\n그림은 전체 항목으로 이동돼요',
          cancelText: '취소',
          onCancel: () => context.pop(),
          confirmText: '삭제',
          onConfirm: () {
            context.pop();
            ref.read(albumEditProvider.notifier).deleteAlbum(album);
          },
        ),
  );
}
