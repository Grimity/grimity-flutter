import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/provider/album_provider.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_album_select.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedUploadAlbumView extends HookConsumerWidget {
  const FeedUploadAlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedUploadState = ref.watch(feedUploadProvider);
    final albumState = ref.watch(albumsProvider);
    final albums = albumState.value ?? [];
    final selectedAlbumId = feedUploadState.albumId;
    final selectedAlbum = albums.firstWhereOrNull((album) => album.id == selectedAlbumId) ?? allAlbum;
    final colors = context.gdsColors;

    return Row(
      spacing: GdsSpacing.spacing32,
      children: [
        Container(
          alignment: Alignment.center,
          height: 44,
          child: Text(
            '앨범',
            style: GdsTypography.subtitle3.copyWith(
              fontSize: 16,
              color: colors.text.grayBold,
            ),
          ),
        ),
        GdsTextButton(
          text: selectedAlbum.name,
          variant: GdsTextButtonVariant.assistive,
          onPressed: () => select(context, ref),
          trailingIcon: GdsIcon.chevronRight,
        ),
      ],
    );
  }

  static void select(BuildContext context, WidgetRef ref) async {
    final feedUploadNotifier = ref.read(feedUploadProvider.notifier);
    final feedUploadState = ref.read(feedUploadProvider);
    final albumState = ref.read(albumsProvider);
    final albums = albumState.value ?? [];
    final selectedAlbumId = feedUploadState.albumId;
    final selectedAlbum = albums.firstWhereOrNull((album) => album.id == selectedAlbumId) ?? allAlbum;

    final newAlbum = await showFeedUploadSelect(context, albums: albums, selectedAlbum: selectedAlbum);
    if (newAlbum != null) {
      feedUploadNotifier.updateAlbumId(newAlbum.id);
    }
  }
}
