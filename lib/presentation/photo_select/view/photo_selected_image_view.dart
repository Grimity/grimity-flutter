import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택된 이미지 표시 ListView
class PhotoSelectedImageListView extends StatelessWidget {
  const PhotoSelectedImageListView({super.key, required this.state});

  final PhotoSelectState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final asset = state.selected[index];

          return _PhotoSelectedImageThumbnail(asset);
        },
        itemCount: state.selected.length,
      ),
    );
  }
}

class _PhotoSelectedImageThumbnail extends ConsumerWidget {
  final AssetEntity asset;

  const _PhotoSelectedImageThumbnail(this.asset);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.gray300, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: PhotoAssetThumbnailWidget(asset: asset, size: 54),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => ref.read(photoSelectProvider.notifier).removeSelectedImage(asset),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF23252B).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Assets.icons.common.close.svg(
                    width: 10,
                    height: 10,
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
