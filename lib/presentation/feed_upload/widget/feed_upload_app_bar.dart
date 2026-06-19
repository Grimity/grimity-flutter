import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/provider/album_provider.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/view/feed_upload_album_view.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_album_select.dart';

class FeedUploadAppBar extends ConsumerWidget {
  const FeedUploadAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedUploadState = ref.watch(feedUploadProvider);
    final canFeedUpload =
        feedUploadState.title.trim().isNotEmpty &&
        feedUploadState.content.trim().isNotEmpty &&
        feedUploadState.images.isNotEmpty;

    final albumState = ref.watch(albumsProvider);
    final albums = albumState.value ?? [];
    final selectedAlbumId = feedUploadState.albumId;
    final selectedAlbum = albums.firstWhereOrNull((album) => album.id == selectedAlbumId) ?? allAlbum;

    return GdsTopNavigation.editor(
      title: selectedAlbum.name,
      label: '업로드',
      saveEnabled: canFeedUpload,
      onBack: () => context.pop(),
      onSave: () => _uploadFeed(context, ref),
      onTitle: () => FeedUploadAlbumView.select(context, ref),
    );
  }

  void _uploadFeed(BuildContext context, WidgetRef ref) async {
    final uploadedFeed = await ref.read(feedUploadProvider.notifier).feedUpload();
    if (uploadedFeed != null && context.mounted) {
      ToastService.showSuccess('그림을 업로드했어요');

      // 업로드된 피드 정보 페이지로 이동
      FeedDetailRoute(id: uploadedFeed.id).pushReplacement(context);
    }
  }
}
