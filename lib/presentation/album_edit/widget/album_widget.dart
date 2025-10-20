import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/widget/album_delete_dialog.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumWidget extends HookConsumerWidget {
  const AlbumWidget({
    super.key,
    required this.album,
    required this.isEditing,
    required this.index,
    required this.showSuffix,
  });

  final Album album;
  final bool isEditing;
  final int index;
  final bool showSuffix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumNameController = useTextEditingController(text: album.name);
    final albumEditNotifier = ref.read(albumEditProvider.notifier);

    useEffect(() {
      if (albumNameController.text != album.name) {
        albumNameController.text = album.name;
      }
      return null;
    }, [album.name]);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: GrimityTextField.normal(
              state: GrimityTextFieldState.disabled,
              controller: albumNameController,
              enabled: isEditing,
              onChanged: (val) => albumEditNotifier.updateAlbumByOne(album.id, val),
              onEdit: () => albumEditNotifier.updateEditAlbum(album),
              onCancel: () => albumEditNotifier.cancelEditAlbum(),
              onSave: () => albumEditNotifier.updateAlbum(album),
              maxLines: 1,
              maxLength: 20,
              showSuffix: showSuffix,
            ),
          ),
          if (!isEditing) ...[
            Gap(8),
            if (ref.watch(albumEditProvider).isAlbumSorting) ...[
              ReorderableDragStartListener(
                index: index,
                child: Assets.icons.profileEdit.dragAndDrop.svg(width: 20, height: 20),
              ),
            ] else ...[
              GestureDetector(
                onTap: () => showAlbumDeleteDialog(context, ref, album),
                child: Assets.icons.common.close.svg(
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(AppColor.gray600, BlendMode.srcIn),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
