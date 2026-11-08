// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:hit/hit.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:grimity/views/show_image_crop_modal.dart';
import 'package:pervice/pervice.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// 프로필 편집 화면에서 프로필 이미지를 표시하고 이를 수정하는 위젯.
class ProfileEditAvatar extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .end,
      mainAxisSize: .min,
      children: [
        // 프로필 이미지 표시
        GdsProfile(
          size: .lg,
          image: model.value.avatar,
        ),

        // 제거 혹은 추가 버튼 표시
        Align(
          widthFactor: 0.5,
          child: FractionalTranslation(
            translation: .new(-0.5, 0),

            // 부모 영역 밖으로 이동한 버튼의 터치도 처리.
            child: HitDefer(
              child: Builder(
                builder: (context) {
                  if (model.value.avatar != null) {
                    return GdsButton.icon(
                      type: .solid,
                      icon: .x,
                      onTap: () {
                        // 프로필 이미지 제거.
                        model.value = model.value.copyWith(avatar: () => null);
                      },
                    );
                  }

                  return GdsButton.icon(
                    type: .solid,
                    icon: .camera,
                    onTap: () => onAddImage(context),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 갤러리에서 선택한 이미지를 자른 뒤 프로필 이미지에 반영합니다.
  void onAddImage(BuildContext context) async {
    final newImages = await context.push<List<AssetEntityImageProvider>?>(
      const GalleryPage(maxCount: 1),
    );

    // 사용자가 이미지를 선택했을 경우.
    if (newImages != null && context.mounted) {
      final resolvedImage = await showImageCropModal(
        context,
        title: '프로필 이미지 수정',
        label: '프로필 저장',
        provider: newImages.single,
        ratio: .square,
        shape: .circle,
      );

      if (resolvedImage != null) {
        model.value = model.value.copyWith(avatar: () => resolvedImage);
      }
    }
  }
}
