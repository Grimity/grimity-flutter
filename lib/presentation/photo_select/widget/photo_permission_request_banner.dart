import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionRequestBanner extends StatelessWidget {
  const PermissionRequestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Container(
      width: double.infinity,
      color: colors.surface.primarySubtlest,
      padding: const EdgeInsets.all(GdsSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GdsSpacing.spacing8,
        children: [
          Text(
            '권한 설정에서 모든 사진 접근 권한을 허용하면 더 많은 그림을  선택해 업로드 할 수 있어요',
            style: GdsTypography.label4.copyWith(color: colors.text.grayBold),
          ),
          GdsGesture(
            onTap: () => PhotoManager.openSetting(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing6,
              children: [
                Text('권한 설정으로 이동', style: GdsTypography.label3.copyWith(color: colors.text.primaryNormal)),
                GdsIcon.chevronRightThick.build(
                  color: colors.icon.primaryNormal,
                  width: GdsIconSize.v16,
                  height: GdsIconSize.v16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
