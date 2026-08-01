import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/extension/string_extension.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_add_image_button.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택된 이미지 표시 View
class FeedUploadSelectedImageView extends ConsumerWidget {
  const FeedUploadSelectedImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedUploadProvider);
    final notifier = ref.read(feedUploadProvider.notifier);

    return SizedBox(
      height: 240,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        ),
        buildDefaultDragHandles: false,
        itemCount: state.images.length + 1,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + (animation.value * 0.1),
                child: Material(
                  type: MaterialType.transparency,
                  color: Colors.transparent,
                  child: child,
                ),
              );
            },
          );
        },
        onReorder: notifier.reorderImage,
        itemBuilder: (context, index) {
          if (index == state.images.length) {
            return FeedUploadAddImageButton(key: const ValueKey('feed-upload-add-image'));
          }

          final imageSource = state.images[index];
          final isThumbnail = state.thumbnailImage == imageSource;

          return ReorderableDelayedDragStartListener(
            key: ObjectKey(imageSource),
            index: index,
            child: Padding(
              padding: EdgeInsets.only(right: GdsSpacing.spacing16),
              child: _FeedUploadSelectedImage(
                imageSource: imageSource,
                isThumbnail: isThumbnail,
                onThumbnailTap: () => notifier.updateThumbnailImage(imageSource),
                onRemoveTap: () => notifier.removeImage(imageSource),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeedUploadSelectedImage extends StatelessWidget {
  const _FeedUploadSelectedImage({
    required this.imageSource,
    required this.isThumbnail,
    required this.onThumbnailTap,
    required this.onRemoveTap,
  });

  final ImageSourceItem imageSource;
  final bool isThumbnail;
  final VoidCallback onThumbnailTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    if (imageSource case AssetImageSource(:final asset)) {
      return _AssetAlbumCard(
        asset: asset,
        isThumbnail: isThumbnail,
        onThumbnailTap: onThumbnailTap,
        onRemoveTap: onRemoveTap,
      );
    }

    final remoteImage = imageSource as RemoteImageSource;

    return GdsAlbumCard(
      type: GdsAlbumCardType.image,
      imageUrlBuilder: (width, height) {
        return remoteImage.url.imageUrlBuilder(context, width, height);
      },
      state: isThumbnail ? GdsAlbumCardState.checked : GdsAlbumCardState.defaultType,
      onTap: onThumbnailTap,
      onCloseTap: onRemoveTap,
    );
  }
}

class _AssetAlbumCard extends StatefulWidget {
  const _AssetAlbumCard({
    required this.asset,
    required this.isThumbnail,
    required this.onThumbnailTap,
    required this.onRemoveTap,
  });

  final AssetEntity asset;
  final bool isThumbnail;
  final VoidCallback onThumbnailTap;
  final VoidCallback onRemoveTap;

  @override
  State<_AssetAlbumCard> createState() => _AssetAlbumCardState();
}

class _AssetAlbumCardState extends State<_AssetAlbumCard> {
  late Future<File?> _file;

  @override
  void initState() {
    super.initState();
    _file = widget.asset.file;
  }

  @override
  void didUpdateWidget(covariant _AssetAlbumCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _file = widget.asset.file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _file,
      builder: (context, snapshot) {
        final file = snapshot.data;

        return GdsAlbumCard(
          type: GdsAlbumCardType.image,
          title: widget.asset.title,
          image: file == null ? null : Image.file(file),
          state: widget.isThumbnail ? GdsAlbumCardState.checked : GdsAlbumCardState.defaultType,
          onTap: widget.onThumbnailTap,
          onCloseTap: widget.onRemoveTap,
        );
      },
    );
  }
}
