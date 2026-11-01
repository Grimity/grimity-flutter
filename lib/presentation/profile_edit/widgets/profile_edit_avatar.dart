// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:pervice/pervice.dart';

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
          image: model().avatar,
        ),

        // 제거 혹은 추가 버튼 표시
        Align(
          widthFactor: 0.5,
          child: FractionalTranslation(
            translation: .new(-0.5, 0),
            child: Builder(
              builder: (context) {
                if (model().avatar != null) {
                  return GdsButton.icon(
                    type: .solid,
                    icon: .x,
                    onTap: () {
                      // 프로필 이미지 제거.
                      model.set(model().copyWith(avatar: () => null));
                    },
                  );
                }

                return GdsButton.icon(
                  type: .solid,
                  icon: .camera,
                  onTap: () async {
                    final newImages = await context.push<List<ImageProvider>?>(
                      const GalleryPage(maxCount: 1),
                    );

                    // 사용자가 이미지를 선택했을 경우.
                    if (newImages != null) {
                      model.set(model().copyWith(avatar: () => newImages.single));
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
