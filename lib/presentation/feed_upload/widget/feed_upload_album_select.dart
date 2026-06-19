import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/album.dart';

final allAlbum = Album(id: '', name: '전체 앨범', feedCount: 0);

Future<Album?> showFeedUploadSelect(
  BuildContext context, {
  required List<Album> albums,
  required Album selectedAlbum,
}) {
  albums = [allAlbum, ...albums];

  final child = Column(
    mainAxisSize: MainAxisSize.min,
    spacing: GdsSpacing.spacing12,
    children: [
      ...albums.map((album) {
        return GdsListItem.optionCard(
          text: album.name,
          state: selectedAlbum == album ? GdsListItemState.pressed : GdsListItemState.enabled,
          onTap: () => context.pop(album),
        );
      }),
    ],
  );

  if (context.isMobile) {
    final bottomSheet = GdsBottomSheet(
      type: GdsBottomSheetType.tertiary,
      onClose: context.pop,
      title: '앨범 선택',
      child: child,
    );

    return bottomSheet.open<Album?>(context);
  } else {
    final modal = GdsModal(title: '앨범 선택', body: child);

    return modal.open<Album?>(context);
  }
}
