// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'album_with_count_response.dart';
import 'link_response.dart';

part 'user_profile_response.freezed.dart';
part 'user_profile_response.g.dart';

@Freezed()
abstract class UserProfileResponse with _$UserProfileResponse {
  const factory UserProfileResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,

    /// 차단 여부
    required bool isBlocked,

    /// not null인데 공백은 허용
    required String description,
    required String? backgroundImage,
    required List<LinkResponse> links,
    required num followerCount,
    required num followingCount,
    required num feedCount,
    required num postCount,
    required bool isFollowing,
    required bool isBlocking,
    required List<AlbumWithCountResponse> albums,
  }) = _UserProfileResponse;

  factory UserProfileResponse.fromJson(Map<String, Object?> json) => _$UserProfileResponseFromJson(json);
}
