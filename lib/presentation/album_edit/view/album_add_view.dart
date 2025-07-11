import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/widget/album_max_count_dialog.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';
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

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('새 앨범 추가', style: AppTypeface.caption1.copyWith(color: AppColor.gray800)),
        ),
        Gap(10),
        Align(
          alignment: Alignment.center,
          child: GrimityTextField.normal(
            state: albumEditState.newAlbumNameState,
            controller: newAlbumController,
            focusNode: newAlbumFocusNode,
            hintText: "예시 : ‘크로키’ 또는 ‘일러스트'",
            maxLines: 1,
            onChanged: (val) => ref.read(albumEditProvider.notifier).updateNewAlbumName(val),
            errorText: albumEditState.albumCheckMessage,
            enabled: albumEditState.isAlbumSorting ? false : true,
          ),
        ),
        Gap(12),
        GrimityButton(
          '추가',
          onTap: () {
            newAlbumFocusNode.unfocus();

            if (ref.read(albumEditProvider).albums.length >= 8) {
              showAlbumMaxCountDialog(context);
              return;
            }

            ref.read(albumEditProvider.notifier).createNewAlbum();
          },
          isEnabled: newAlbumController.text.isEmpty || albumEditState.isAlbumSorting ? false : true,
          isFullWidth: false,
          hasBottomPadding: false,
        ),
        Gap(40),
      ],
    );
  }
}
