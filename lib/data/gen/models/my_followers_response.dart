// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'follower_user_response.dart';

part 'my_followers_response.freezed.dart';
part 'my_followers_response.g.dart';

@Freezed()
abstract class MyFollowersResponse with _$MyFollowersResponse {
  const factory MyFollowersResponse({
    required String? nextCursor,
    required List<FollowerUserResponse> followers,
  }) = _MyFollowersResponse;

  factory MyFollowersResponse.fromJson(Map<String, Object?> json) => _$MyFollowersResponseFromJson(json);
}
