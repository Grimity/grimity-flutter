import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_provider.dart';
import 'package:grimity/presentation/album_organize/widget/album_organize_fab_button.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_select_modal_bottom_sheet.dart';
import 'package:grimity/app/config/app_color.dart';

class AlbumOrganizeFabView extends ConsumerWidget with AlbumOrganizeMixin {
  const AlbumOrganizeFabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = albumOrganizeState(ref);
    final userAlbums = state.userAlbums;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        AlbumOrganizeFabButton(
          title: '선택 삭제',
          asset: Assets.icons.common.close,
          onTap: () => _showDeleteDialog(context, ref),
        ),

        // 유저가 생성한 앨범이 있을때 만 표시
        if (userAlbums.isNotEmpty)
          AlbumOrganizeFabButton(
            title: '앨범 이동',
            asset: Assets.icons.common.deliver,
            onTap: () => _showMoveBottomSheet(context, ref, state.ids.length),
          ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return GrimityDialog(
          title: '선택한 그림을 삭제할까요?',
          content: '삭제 이후 되돌릴 수 없어요',
          cancelText: '취소',
          onCancel: () => context.pop(),
          confirmText: '삭제',
          onConfirm: () {
            context.pop();
            albumOrganizeNotifier(ref).deleteFeeds();
          },
        );
      },
    );
  }

  void _showMoveBottomSheet(BuildContext context, WidgetRef ref, int count) {
    GrimitySelectModalBottomSheet.show(
      context,
      titleWidget: RichText(
        text: TextSpan(
          style: AppTypeface.subTitle3,
          children: [
            TextSpan(text: '선택한 '),
            TextSpan(text: '$count', style: AppTypeface.subTitle3.copyWith(color: AppColor.main)),
            TextSpan(text: '개의 그림 이동'),
          ],
        ),
      ),
      buttonsBuilder: (ref) {
        final state = albumOrganizeState(ref);
        final notifier = albumOrganizeNotifier(ref);

        return [
          GrimitySelectModalButtonModel(
            title: '전체 앨범',
            isSelected: state.targetAlbumId == null,
            isDisabled: state.currentAlbumId == null,
            onTap: () => notifier.updateTargetAlbumId(null),
          ),
          ...state.userAlbums.map((album) {
            return GrimitySelectModalButtonModel(
              title: album.name,
              isSelected: state.targetAlbumId == album.id,
              isDisabled: state.currentAlbumId == album.id,
              onTap: () => notifier.updateTargetAlbumId(album.id),
            );
          }),
        ];
      },
      onSave: () {
        context.pop();
        albumOrganizeNotifier(ref).moveFeeds();
      },
    );
  }
}
