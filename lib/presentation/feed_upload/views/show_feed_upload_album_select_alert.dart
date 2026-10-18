import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';

/// 피드를 업로드할 앨범을 선택하는 팝업을 표시합니다.
Future<void> showFeedUploadAlbumSelectAlert(
  BuildContext context,
  String? selectedAlbum,
) async {
  final modal = GdsAdaptiveModal(
    title: '앨범명 변경',
    children: AppUser.albums.builder((album) {
      final isSelected = album.id == selectedAlbum;

      return GdsListItem.optionCard(
        status: isSelected ? .selected : .enabled,
        label: album.name,

        // 선택되지 않은 앨범을 누르면 앨범명을 반환하고 팝업 닫기.
        onTap: isSelected ? null : () => context.pop(album.id),
      );
    }),
  );

  return modal.open(context);
}
