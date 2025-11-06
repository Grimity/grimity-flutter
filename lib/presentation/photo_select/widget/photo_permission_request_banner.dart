import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionRequestBanner extends StatelessWidget {
  const PermissionRequestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.gray200,
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 10,
        children: [
          Text(
            '권한 설정에서 모든 사진 접근 권한을 허용하면 더 많은 그림을 선택해 업로드 할 수 있어요',
            style: AppTypeface.label3.copyWith(color: AppColor.gray600),
          ),
          GrimityGesture(
            onTap: () => PhotoManager.openSetting(),
            child: Row(
              children: [
                Text('권한 설정으로 이동', style: AppTypeface.label2.copyWith(color: AppColor.main)),
                Icon(Icons.chevron_right, size: 16, color: AppColor.main),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
