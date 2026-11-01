// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/presentation/gallery/pages/gallery_page.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:pervice/pervice.dart';

/// 프로필 편집 화면에서 커버 이미지를 표시하고 이를 수정하는 위젯.
class ProfileEditBanner extends StatelessWidget {
  const new({
    super.key,
    required this.model,
  });

  final ValueState<ProfileEditModel> model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: .center,
      children: [
        // 배너 이미지 표시
        GdsThumbnail(
          ratio: .banner,
          provider: model.value.banner,
        ),

        // 플레이스 홀더 이미지인 경우에만 표시
        if (model.value.banner == null) ...[
          Positioned.fill(
            child: GdsContainer(
              color: .bgBlack,
              opacity: .opacity20,
            ),
          ),
        ],

        // 액션 버튼 표시
        Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            GdsButton.icon(
              type: .solid,
              icon: .camera,
              onTap: () async {
                final newImages = await context.push<List<ImageProvider>?>(
                  const GalleryPage(maxCount: 1),
                );

                // 사용자가 이미지를 선택했을 경우.
                if (newImages != null) {
                  model.value = model.value.copyWith(banner: () => newImages.single);
                }
              },
            ),

            GdsButton.icon(
              type: .solid,
              icon: .x,
              enabled: model.value.banner != null,
              onTap: () {
                // 배너 이미지 제거.
                model.value = model.value.copyWith(banner: () => null);
              },
            ),
          ],
        ),
      ],
    );
  }
}
