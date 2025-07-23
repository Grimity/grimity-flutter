import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_add_image_button.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';
import 'package:photo_manager/photo_manager.dart';

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
          ...state.images.map((asset) {
            final isThumbnail = state.thumbnailImage == asset;
            final isFirst = state.images.first == asset;

            return Padding(
              padding: EdgeInsets.only(left: isFirst ? 16 : 0, right: 12),
              child: _FeedUploadSelectedImage(
                asset: asset,
                isThumbnail: isThumbnail,
                onThumbnailTap: () => notifier.updateThumbnailImage(asset),
                onRemoveTap: () => notifier.removeImage(asset),
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
            child: PhotoAssetThumbnailWidget(asset: asset, fit: BoxFit.contain),
          ),
        ),

        Positioned(
          left: 8,
          top: 8,
          child: GestureDetector(
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
                  Assets.icons.feedUpload.check.svg(
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
          child: GestureDetector(
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
