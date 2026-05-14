import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/view/album_reorderable_list_view.dart';

class AlbumEditListView extends ConsumerWidget {
  const AlbumEditListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdsColors;
    final albumEditState = ref.watch(albumEditProvider);
    final albums = albumEditState.albums;
    final isSorting = albumEditState.isAlbumSorting;

    return Column(
      spacing: GdsSpacing.spacing8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GdsTitle(text: '앨범 목록', isRequired: false),
            if (albums.isNotEmpty)
              GdsTextButton(
                size: GdsTextButtonSize.regular,
                text: isSorting ? '완료' : '순서 편집',
                onPressed: () => ref.read(albumEditProvider.notifier).toggleIsAlbumSorting(),
                variant: isSorting ? GdsTextButtonVariant.primary : GdsTextButtonVariant.assistive,
                trailingIcon: isSorting ? null : GdsIcon.sortHorizontal,
              ),
          ],
        ),

        if (albums.isEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing32),
            child: Column(
              spacing: GdsSpacing.spacing8,
              children: [
                Text('아직 생성된 앨범이 없어요', style: GdsTypography.subtitle2.copyWith(color: colors.text.grayBold)),
                Text('앨범을 추가하면 그림을 분류할 수 있어요', style: GdsTypography.label4.copyWith(color: colors.text.graySubtle)),
              ],
            ),
          ),
        ] else
          AlbumReorderableListView(),
      ],
    );
  }
}
