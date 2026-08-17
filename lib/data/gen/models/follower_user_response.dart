// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower_user_response.freezed.dart';
part 'follower_user_response.g.dart';

@Freezed()
abstract class FollowerUserResponse with _$FollowerUserResponse {
  const factory FollowerUserResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,

    /// not null인데 공백은 허용
    required String description,

    /// 내가 이 팔로워를 맞팔로우 중인지
    required bool isFollowing,
  }) = _FollowerUserResponse;

  factory FollowerUserResponse.fromJson(Map<String, Object?> json) => _$FollowerUserResponseFromJson(json);
}
