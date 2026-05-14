import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';

void showAlbumDeleteDialog(BuildContext context, WidgetRef ref, Album album) {
  final alert = GdsAlert(
    type: GdsAlertType.content,
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '앨범을 삭제할까요?',
    description: '앨범을 삭제하면\n그림은 전체 항목으로 이동돼요',
    primaryLabel: '삭제하기',
    secondaryLabel: '아니요',
    onPrimaryTap: () {
      context.pop();
      ref.read(albumEditProvider.notifier).deleteAlbum(album);
    },
    onSecondaryTap: context.pop,
  );

  alert.open(context);
}
