import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumAddView extends HookConsumerWidget {
  const AlbumAddView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumEditState = ref.watch(albumEditProvider);
    final newAlbumController = useTextEditingController(text: ref.watch(albumEditProvider).newAlbumName);
    final newAlbumFocusNode = useFocusNode();

    useEffect(() {
      if (newAlbumController.text != albumEditState.newAlbumName) {
        newAlbumController.text = albumEditState.newAlbumName;
      }

      return null;
    }, [albumEditState.newAlbumName]);

    useEffect(() {
      void onFocusChange() {
        if (!newAlbumFocusNode.hasFocus && newAlbumController.text != albumEditState.newAlbumName) {
          ref.read(albumEditProvider.notifier).updateNewAlbumName(newAlbumController.text);
        }
      }

      newAlbumFocusNode.addListener(onFocusChange);
      return () {
        newAlbumFocusNode.removeListener(onFocusChange);
      };
    }, [newAlbumFocusNode, albumEditState.newAlbumName]);

    return GdsInput.button(
      titleText: '새 앨범 추가',
      helperText:
          albumEditState.newAlbumNameState == GrimityTextFieldState.error
              ? albumEditState.albumCheckMessage
              : '앨범은 최대 8개까지 추가 가능합니다.',
      placeholder: '예시 : ‘크로키’ 또는 ‘일러스트’',
      buttonLabel: '추가',
      controller: newAlbumController,
      focusNode: newAlbumFocusNode,
      enabled: albumEditState.isAlbumSorting == false,
      error: albumEditState.newAlbumNameState == GrimityTextFieldState.error,
      success: albumEditState.newAlbumNameState == GrimityTextFieldState.success,
      onChanged: (val) => ref.read(albumEditProvider.notifier).updateNewAlbumName(val),
      buttonEnabled: newAlbumController.text.isNotEmpty && albumEditState.isAlbumSorting == false,
      onButtonPressed: () {
        newAlbumFocusNode.unfocus();

        if (ref.read(albumEditProvider).albums.length >= 8) {
          return;
        }

        ref.read(albumEditProvider.notifier).createNewAlbum();
      },
    );
  }
}
