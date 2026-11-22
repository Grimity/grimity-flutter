// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:pervice/pervice.dart';

/// 프로필 URL을 입력하고 변경 사항을 저장하는 설정 페이지.
class SettingsProfileUrl extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final oldUrl = profile.url;
    final newUrl = context.stateOf(() => oldUrl);

    // 프로필 URL이 변경되어 제출할 수 있는지 여부.
    final canSubmit = oldUrl != newUrl.value;

    // 입력한 새 프로필 URL을 프로필에 반영합니다.
    void onSubmit() async {
      try {
        final service = PutMe(
          request: .new(
            name: profile.name,
            url: newUrl.value,
            description: profile.description,
          ),
        );

        // 프로필 URL 변경 후 현재 사용자 정보 갱신.
        await service.request();
        await AppUser.refresh();

        // 프로필 URL 설정 화면을 닫고 변경 완료 메시지 표시.
        if (context.mounted) {
          context.pop();
          GdsToast.show('프로필 URL이 변경되었어요', status: .positive);
        }
      } catch (_) {
        GdsToast.show('프로필 URL 변경에 실패했어요', status: .negative);
        rethrow;
      }
    }

    return GdsScaffold(
      appBar: GdsTopNavigation.iconButton(
        onBack: context.pop,
        title: '닉네임',
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: GdsScrollable(
              padding: context.whenDevice(
                mobile: 40.top + 16.bottom + 16.horizontal,
                tablet: 48.top + 40.bottom + 40.horizontal,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // 안내 문구 표시
                  GdsText(
                    '프로필 URL을 정해주세요',
                    color: .textGrayBold,
                    style: context.whenDevice(
                      mobile: .title2,
                      tablet: .title1,
                    ),
                  ),
                  const Gap(40),

                  // 프로필 URL의 기본 주소 표시
                  GdsText(
                    'www.grimity.com/',
                    color: .textGrayBold,
                    style: context.whenDevice(
                      mobile: .title2,
                      tablet: .title1,
                    ),
                  ),
                  const Gap(12),

                  // 입력 필드 표시
                  GdsTextField.normal(
                    size: .md,
                    initialText: oldUrl,
                    placeholder: '숫자, 영문(소문자), 언더바(_)',
                    onChanged: newUrl.setter,
                  ),
                ],
              ),
            ),
          ),

          // 제출 버튼 표시
          Padding(
            padding: context.whenDevice(
              mobile: 24.bottom + 16.horizontal,
              tablet: 40.bottom + 40.horizontal,
            ),
            child: GdsButton.text(
              type: .solid,
              size: .lg,
              label: '저장하기',
              mainAxisSize: .max,
              enabled: canSubmit,
              onTap: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
