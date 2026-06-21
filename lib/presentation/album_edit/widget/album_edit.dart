import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showAlbumEdit(
  BuildContext context,
  Album album,
  WidgetRef ref, {
  FutureOr<bool> Function(Album album)? onEdited,
}) async {
  final editController = TextEditingController(text: album.name);
  final editFocusNode = FocusNode();

  void closeNameEditor() {
    editFocusNode.unfocus();
    Navigator.pop(context);
  }

  void disposeNameEditor() {
    editFocusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editController.dispose();
      editFocusNode.dispose();
    });
  }

  Future<void> onPrimaryTap() async {
    final editedName = editController.text.trim();
    if (editedName == album.name.trim()) {
      closeNameEditor();
      return;
    }

    final editedAlbum = album.copyWith(name: editedName);
    final didEdit =
        await (onEdited?.call(editedAlbum) ?? ref.read(albumEditProvider.notifier).updateAlbum(editedAlbum));
    if (didEdit) {
      closeNameEditor();
    }
  }

  if (context.isMobile) {
    final bottomSheet = GdsBottomSheet(
      title: '앨범명 변경',
      onClose: closeNameEditor,
      primaryLabel: '변경하기',
      secondaryLabel: '닫기',
      onPrimaryTap: () => onPrimaryTap(),
      onSecondaryTap: closeNameEditor,
      child: GdsTextField(
        controller: editController,
        focusNode: editFocusNode,
        size: GdsTextFieldSize.medium,
      ),
    );

    await bottomSheet.open(context).whenComplete(disposeNameEditor);
  } else {
    final modal = GdsModal(
      title: '앨범명 변경',
      primaryLabel: '변경하기',
      secondaryLabel: '닫기',
      onPrimary: () => onPrimaryTap(),
      onSecondary: closeNameEditor,
      onClose: closeNameEditor,
      body: GdsTextField(
        controller: editController,
        focusNode: editFocusNode,
        size: GdsTextFieldSize.medium,
      ),
    );

    await modal.open(context, isBarrierDismissible: true).whenComplete(disposeNameEditor);
  }
}
