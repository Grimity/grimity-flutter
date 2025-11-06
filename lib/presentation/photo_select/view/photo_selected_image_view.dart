import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/widget/photo_asset_thumbnail_widget.dart';

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
          final imageSource = state.selected[index];

          return _PhotoSelectedImageThumbnail(imageSource);
        },
        itemCount: state.selected.length,
      ),
    );
  }
}

class _PhotoSelectedImageThumbnail extends ConsumerWidget with PhotoSelectMixin {
  final ImageSourceItem imageSource;

  const _PhotoSelectedImageThumbnail(this.imageSource);

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
                child:
                    imageSource is AssetImageSource
                        ? PhotoAssetThumbnailWidget(asset: (imageSource as AssetImageSource).asset, size: 54)
                        : GrimityCachedNetworkImage.cover(
                          imageUrl: (imageSource as RemoteImageSource).url,
                          width: 54,
                          height: 54,
                        ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => photoNotifier(ref).removeSelectedImage(imageSource),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF23252B).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Assets.icons.common.close.svg(
                      width: 10,
                      height: 10,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
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
