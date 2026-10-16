import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

/// 전체 사진 접근 권한을 안내하고 앱 설정으로 이동하는 버튼을 제공하는 배너 위젯.
class GalleryPermissionBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsContainer(
      padding: .all(16),
      child: Column(
        mainAxisSize: .min,
        children: [
          // 안내 텍스트 표시
          GdsText(
            '권한 설정에서 모든 사진 접근 권한을 허용하면'
            ' 더 많은 그림을 선택해 업로드 할 수 있어요',
            color: .textGrayBold,
            style: .label4,
          ),

          // 이동 버튼 표시
          GdsButton.text(
            size: .sm,
            type: .borderless,
            variant: .primary,
            leadingIcon: .chevronRight,
            label: '권한 설정으로 이동',
            onTap: PhotoManager.openSetting,
          ),
        ],
      ),
    );
  }
}
