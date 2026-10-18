import 'package:flexible_horizontal_list_view/flexible_horizontal_list_view.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/asset_entity.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager/photo_manager.dart';

/// 선택한 이미지의 미리보기와 선택 해제 버튼을 가로로 표시하는 위젯.
class GallerySelectionBar extends StatelessWidget {
  const new({
    super.key,
    required this.selectedImages,
  });

  final ValueState<List<AssetEntity>> selectedImages;

  @override
  Widget build(BuildContext context) {
    return HorizontalListView.separated(
      padding: .symmetric(vertical: 12, horizontal: 12),
      clipBehavior: .none,
      separatorBuilder: (_, _) => const Gap(8),

      // 대용량 이미지로 인한 성능 이슈로 0 픽셀로 조정.
      cacheExtent: 0,
      itemCount: selectedImages.value.length,
      itemBuilder: (context, index) {
        final asset = selectedImages.value[index];

        return Stack(
          children: [
            // 이미지 표시
            GdsThumbnail(
              width: 72,
              ratio: .square,
              radius: .xs,
              provider: asset.toImage(),
            ),

            // 선택 해제 버튼 표시
            Positioned(
              top: 2,
              right: 2,
              child: _DeleteButton(
                onTap: () => selectedImages.remove(asset),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 이미지의 선택을 해제하는 버튼 위젯.
class _DeleteButton extends StatelessWidget {
  const new({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: onTap,
      child: GdsContainer(
        opacity: .opacity60,
        color: .bgBlack,
        radius: .xs,
        child: GdsIcon.x.build(size: 16, color: .iconWhite),
      ),
    );
  }
}
