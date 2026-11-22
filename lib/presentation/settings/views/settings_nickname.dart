// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:pervice/pervice.dart';

/// 닉네임을 입력하고 변경 사항을 저장하는 설정 페이지.
class SettingsNickname extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final oldNickname = profile.name;
    final newNickname = context.stateOf(() => oldNickname);

    // 닉네임이 변경되어 제출할 수 있는지 여부.
    final canSubmit = oldNickname != newNickname.value;

    // 입력한 새 닉네임을 프로필에 반영합니다.
    void onSubmit() async {
      try {
        final service = PutMe(
          request: .new(
            name: newNickname.value,
            url: profile.url,
            description: profile.description,
          ),
        );

        // 닉네임 변경 후 현재 사용자 정보 갱신.
        await service.request();
        await AppUser.refresh();

        // 닉네임 설정 화면을 닫고 변경 완료 메시지 표시.
        if (context.mounted) {
          context.pop();
          GdsToast.show('닉네임이 변경되었어요', status: .positive);
        }
      } catch (_) {
        GdsToast.show('닉네임 변경에 실패했어요', status: .negative);
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
                spacing: 24,
                children: [
                  // 안내 문구 표시
                  GdsText(
                    '새로운 닉네임을 입력해주세요',
                    color: .textGrayBold,
                    style: context.whenDevice(
                      mobile: .title2,
                      tablet: .title1,
                    ),
                  ),

                  // 입력 필드 표시
                  GdsTextField.normal(
                    size: .md,
                    initialText: oldNickname,
                    placeholder: '닉네임을 입력해주세요',
                    maxLength: 12,
                    onChanged: newNickname.setter,
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
