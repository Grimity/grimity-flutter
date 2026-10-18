import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/asset_entity_extension.dart';
import 'package:photo_manager/photo_manager.dart';

/// 앨범의 대표 이미지, 이름과 이미지 개수를 표시하는 선택 항목 위젯.
class GalleryAlbum extends StatelessWidget {
  const new({
    super.key,
    required this.entity,
    required this.onTap,
  });

  final AssetPathEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GdsGesture(
      onTap: onTap,
      child: Padding(
        padding: .symmetric(vertical: 10, horizontal: 16),
        child: Row(
          spacing: 16,
          children: [
            // 대표 이미지 표시
            FutureBuilder(
              future: entity.getAssetListRange(start: 0, end: 1),
              builder: (context, snapshot) {
                final asset = snapshot.data?.singleOrNull;
                final image = asset?.toImage();

                return GdsThumbnail(
                  width: 48,
                  ratio: .square,
                  radius: .xs,
                  provider: image,
                );
              },
            ),

            // 메타데이터 표시
            Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                // 제목 표시
                GdsText(
                  entity.isAll ? '최근 항목' : entity.name,
                  color: .textGrayBold,
                  style: .label3,
                ),

                // 이미지 개수 표시
                FutureBuilder(
                  future: entity.assetCountAsync,
                  builder: (context, snapshot) {
                    final count = snapshot.data?.toString() ?? '-';

                    return GdsText(
                      count,
                      color: .textGraySubtle,
                      style: .label6,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
