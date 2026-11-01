// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/model/user_profile_response.dart';
import 'package:grimity/presentation/profile_edit/screens/profile_edit_screen.dart';

/// 사용자 프로필의 배너 이미지를 표시하는 위젯.
class ProfileBanner extends StatelessWidget {
  const new({
    super.key,
    required this.service,
  });

  final GetUsersProfileByUrl service;

  /// 서비스에서 불러온 사용자 프로필 정보.
  UserProfileResponse get data => service.data;

  /// 프로필 배너 이미지의 가로/세로 비율.
  static const radio = GdsThumbnailRatio.banner;

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      final isEdited = await ProfileEditScreen().push<bool?>(context);

      // 프로필이 수정되었을 경우 사용자 정보 갱신.
      if (context.mounted && isEdited == true) {
        service.refresh();
      }
    }

    if (data.isMe && data.backgroundImage == null) {
      if (context.isMobile) {
        return GdsGesture(
          useEffect: false,
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: radio.value,
            child: GdsContainer(
              color: .bgOverlayBlack,
            ),
          ),
        );
      }

      // Tablet
      return AspectRatio(
        aspectRatio: radio.value,
        child: GdsContainer(
          alignment: .center,
          color: .bgOverlayBlack,
          child: GdsButton.text(
            type: .solid,
            size: .md,
            leadingIcon: .plus,
            label: '커버 추가하기',
            onTap: onTap,
          ),
        ),
      );
    }

    return GdsThumbnail(
      ratio: radio,
      provider: data.backgroundImage?.toImage(),
    );
  }
}
