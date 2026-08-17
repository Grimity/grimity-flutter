// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'link_response.dart';
import 'social_provider.dart';

part 'my_profile_response.freezed.dart';
part 'my_profile_response.g.dart';

@Freezed()
abstract class MyProfileResponse with _$MyProfileResponse {
  const factory MyProfileResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,
    required SocialProvider provider,
    required String email,
    required String? backgroundImage,

    /// not null인데 공백 허용
    required String description,
    required List<LinkResponse> links,
    required DateTime createdAt,
    required bool hasNotification,
    required bool hasUnreadChatMessage,
    required num followerCount,
    required num followingCount,
    required bool isVerified,
  }) = _MyProfileResponse;

  factory MyProfileResponse.fromJson(Map<String, Object?> json) => _$MyProfileResponseFromJson(json);
}
