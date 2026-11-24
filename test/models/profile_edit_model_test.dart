// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/profile_edit/models/profile_edit_model.dart';

void main() {
  setUp(() {
    AppUser.profile = MyProfileResponse(
      id: '1',
      name: '작가',
      url: 'artist',
      provider: .google,
      email: 'artist@example.com',
      description: '소개',
      links: [],
      createdAt: DateTime(2026),
      hasNotification: false,
      hasUnreadChatMessage: false,
      followerCount: 0,
      followingCount: 0,
      isVerified: false,
    );
  });

  test('프로필에 변경 사항이 없으면 제출할 수 없는지 확인', () {
    expect(ProfileEditModel.current().canSubmit, isFalse);
  });

  test('프로필을 수정하면 제출할 수 있고 되돌리면 제출할 수 없는지 확인', () {
    final oldModel = ProfileEditModel.current();
    final newModel = oldModel.copyWith(nickname: '새 작가');
    expect(newModel.canSubmit, isTrue);

    // 닉네임을 원래대로 되돌리면 제출 불가.
    expect(newModel.copyWith(nickname: oldModel.nickname).canSubmit, isFalse);

    // 자기소개를 비워도 변경 사항이 있으면 제출 가능.
    expect(oldModel.copyWith(description: '').canSubmit, isTrue);

    // 프로필 이미지만 변경해도 제출 가능.
    expect(oldModel.copyWith(avatar: () => const AssetImage('avatar.png')).canSubmit, isTrue);

    // 배너 이미지만 변경해도 제출 가능.
    expect(oldModel.copyWith(banner: () => const AssetImage('banner.png')).canSubmit, isTrue);
  });

  test('닉네임이 두 글자 미만이거나 URL이 공백이면 제출할 수 없는지 확인', () {
    final model = ProfileEditModel.current();

    // 앞뒤 공백을 제외한 닉네임이 두 글자 이상일 때만 제출 가능.
    expect(model.copyWith(nickname: '').canSubmit, isFalse);
    expect(model.copyWith(nickname: ' 가 ').canSubmit, isFalse);
    expect(model.copyWith(nickname: '새 작가').canSubmit, isTrue);

    // URL이 공백과 줄바꿈으로만 이루어져 있으면 제출 불가.
    expect(model.copyWith(url: ' \n ').canSubmit, isFalse);
  });

  test('이름이나 주소가 비어 있는 링크가 있으면 제출할 수 없는지 확인', () {
    final model = ProfileEditModel.current();

    // 링크 이름이 공백으로만 이루어져 있으면 제출 불가.
    {
      final link = const LinkResponse(
        linkName: ' ',
        link: 'https://example.com',
      );

      final newModel = model.copyWith(links: [link]);
      expect(newModel.canSubmit, isFalse);
    }

    // 링크 주소가 공백과 줄바꿈으로만 이루어져 있으면 제출 불가.
    {
      final link = const LinkResponse(
        linkName: '홈페이지',
        link: ' \n ',
      );

      final newModel = model.copyWith(links: [link]);
      expect(newModel.canSubmit, isFalse);
    }

    // 이름과 주소가 유효한 링크를 추가하면 제출 가능.
    {
      final link = const LinkResponse(
        linkName: '홈페이지',
        link: 'https://example.com',
      );

      final newModel = model.copyWith(links: [link]);
      expect(newModel.canSubmit, isTrue);
    }
  });
}
