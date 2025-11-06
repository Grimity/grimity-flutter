import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_add_image_button.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

/// 선택된 이미지 표시 View
class FeedUploadSelectedImageView extends ConsumerWidget {
  const FeedUploadSelectedImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedUploadProvider);
    final notifier = ref.read(feedUploadProvider.notifier);

    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...state.images.map((imageSource) {
            final isThumbnail = state.thumbnailImage == imageSource;
            final isFirst = state.images.first == imageSource;

            return Padding(
              padding: EdgeInsets.only(left: isFirst ? 16 : 0, right: 12),
              child: _FeedUploadSelectedImage(
                imageSource: imageSource,
                isThumbnail: isThumbnail,
                onThumbnailTap: () => notifier.updateThumbnailImage(imageSource),
                onRemoveTap: () => notifier.removeImage(imageSource),
              ),
            );
          }),
          Padding(padding: EdgeInsets.only(right: 16), child: FeedUploadAddImageButton()),
        ],
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
    return Stack(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: AppColor.gray200,
            borderRadius: BorderRadius.circular(12),
            border: isThumbnail ? Border.all(color: AppColor.main, width: 1) : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageSource is AssetImageSource
                    ? PhotoAssetThumbnailWidget(asset: (imageSource as AssetImageSource).asset, fit: BoxFit.contain)
                    : GrimityCachedNetworkImage.contain(
                      imageUrl: (imageSource as RemoteImageSource).url,
                      width: 160,
                      height: 160,
                    ),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: GrimityGesture(
            onTap: isThumbnail ? null : () => onThumbnailTap.call(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: isThumbnail ? AppColor.main : AppColor.gray00,
                border: Border.all(color: isThumbnail ? AppColor.main : AppColor.gray300, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                spacing: 2,
                children: [
                  Assets.icons.common.check.svg(
                    colorFilter: ColorFilter.mode(isThumbnail ? AppColor.gray00 : AppColor.gray500, BlendMode.srcIn),
                  ),
                  Text(
                    '대표',
                    style: AppTypeface.caption3.copyWith(color: isThumbnail ? AppColor.gray00 : AppColor.gray500),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          right: 8,
          top: 8,
          child: GrimityGesture(
            onTap: () => onRemoveTap.call(),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF23252B).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Assets.icons.common.close.svg(
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(AppColor.gray300, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
