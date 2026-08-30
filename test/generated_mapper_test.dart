import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/data/gen/models/auth_provider.dart';
import 'package:grimity/data/gen/models/link_response.dart';
import 'package:grimity/data/gen/models/login_request.dart';
import 'package:grimity/data/gen/models/my_profile_response.dart';
import 'package:grimity/data/gen/models/social_provider.dart';
import 'package:grimity/data/mapper/generated_me_mapper.dart';

void main() {
  test('생성된 로그인 요청의 enum이 JSON 값으로 직렬화되는 걸 확인', () {
    const request = LoginRequest(
      provider: AuthProvider.google,
      providerAccessToken: 'oauth-token',
      deviceId: 'device-id',
    );

    expect(request.toJson()['provider'], 'GOOGLE');
    expect(jsonEncode(request.toJson()), contains('"provider":"GOOGLE"'));
  });

  test('생성된 중첩 링크 응답을 도메인 링크로 변환되는 걸 확인', () {
    final response = MyProfileResponse(
      id: 'user-id',
      name: 'name',
      image: null,
      url: 'profile',
      provider: SocialProvider.google,
      email: 'test@example.com',
      backgroundImage: null,
      description: '',
      links: const [LinkResponse(linkName: 'website', link: 'https://example.com')],
      createdAt: DateTime.utc(2026),
      hasNotification: false,
      hasUnreadChatMessage: false,
      followerCount: 1,
      followingCount: 2,
      isVerified: false,
    );

    final user = response.toEntity();

    expect(user.links, hasLength(1));
    expect(user.links!.single.linkName, 'website');
    expect(user.links!.single.link, 'https://example.com');
  });
}
