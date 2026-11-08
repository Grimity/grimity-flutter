// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_image.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_avatar.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_banner.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_description.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_links.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_nickname.dart';
import 'package:grimity/presentation/profile_edit/widgets/profile_edit_url.dart';
import 'package:hit/hit.dart';
import 'package:pervice/pervice.dart';

/// 프로필 이미지와 닉네임, 소개글, 외부 링크를 수정하는 화면.
class ProfileEditScreen extends GdsEditorScreen {
  const new();

  @override
  String get title => '프로필 수정';

  @override
  EdgeInsets get padding => .zero;

  @override
  GdsEditorContent build(BuildContext context) {
    final model = context.stateOf(ProfileEditModel.current);

    return .new(
      submitButton: .new(
        label: '저장',
        onTap: () => submit(context, model.value),
        enabled: model.value.canSubmit,
      ),
      child: HitScope(
        child: Column(
          mainAxisSize: .min,
          children: [
            // 배너 이미지 표시
            ProfileEditBanner(model: model),

            // 본문 표시
            Padding(
              padding: .only(bottom: 16, left: 16, right: 16),
              child: Column(
                mainAxisSize: .min,
                spacing: 20,
                children: [
                  // 프로필 이미지 표시
                  Align(
                    alignment: .centerLeft,
                    heightFactor: 0.5,
                    child: FractionalTranslation(
                      translation: .new(0, -0.25),
                      child: ProfileEditAvatar(model: model),
                    ),
                  ),

                  // 닉네임 입력 필드 표시
                  ProfileEditNickname(model: model),

                  // 자기소개 입력 필드 표시
                  ProfileEditDescription(model: model),

                  // URL 입력 필드 표시
                  ProfileEditUrl(model: model),

                  // 외부 링크 입력 필드 표시
                  ProfileEditLinks(model: model),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 입력한 프로필 정보와 이미지의 변경을 요청합니다.
  Future<void> submit(
    BuildContext context,
    ProfileEditModel model,
  ) async {
    final (avatar, banner) = await (
      AppImage.resolve([?model.avatar], .profile),
      AppImage.resolve([?model.banner], .profile),
    ).wait;

    // 프로필 이미지가 있으면 수정을, 없으면 삭제를 요청.
    if (avatar.isNotEmpty) {
      await PutMeImage(request: .new(imageName: avatar.single.name)).request();
    } else {
      await DeleteMeImage().request();
    }

    // 배너 이미지가 있으면 수정을, 없으면 삭제를 요청.
    if (banner.isNotEmpty) {
      await PutMeBackground(request: .new(imageName: banner.single.name)).request();
    } else {
      await DeleteMeBackground().request();
    }

    final service = PutMe(
      request: .new(
        name: model.nickname,
        url: model.url,
        description: model.description,
        links: model.links.builder((e) => .new(linkName: e.linkName, link: e.link)),
      ),
    );

    await service.request();

    // 프로필 편집 화면을 닫고 수정 완료 메시지 표시.
    if (context.mounted) {
      context.pop(true);
      GdsToast.show('프로필 수정이 완료되었어요', status: .positive);
    }
  }
}
