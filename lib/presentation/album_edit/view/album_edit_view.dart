import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/album_edit/provider/album_data_provider.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';
import 'package:grimity/presentation/album_edit/view/album_reorderable_list_view.dart';
import 'package:grimity/presentation/album_edit/widget/album_empty_widget.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';

class AlbumEditListView extends ConsumerWidget {
  const AlbumEditListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumAsync = ref.watch(albumDataProvider);
    final albumEditState = ref.watch(albumEditProvider);
    final albums = albumEditState.albums;
    final isSorting = albumEditState.isAlbumSorting;

    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            Text('앨범 목록', style: AppTypeface.caption1.copyWith(color: AppColor.gray800)),
            const Spacer(),
            if (albums.isNotEmpty)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => ref.read(albumEditProvider.notifier).toggleIsAlbumSorting(),
                child: Text(
                  isSorting ? '완료' : '순서 편집',
                  style: AppTypeface.caption1.copyWith(color: isSorting ? AppColor.main : AppColor.gray500),
                ),
              ),
          ],
        ),
        albumAsync.maybeWhen(
          data: (_) => albums.isEmpty ? AlbumEmptyWidget() : AlbumReorderableListView(),
          orElse: () => Padding(padding: EdgeInsets.symmetric(vertical: 80), child: GrimityCircularProgressIndicator()),
        ),
      ],
    );
  }
}
