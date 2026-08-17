// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'follow_user_response.dart';

part 'my_followings_response.freezed.dart';
part 'my_followings_response.g.dart';

@Freezed()
abstract class MyFollowingsResponse with _$MyFollowingsResponse {
  const factory MyFollowingsResponse({
    required String? nextCursor,
    required List<FollowUserResponse> followings,
  }) = _MyFollowingsResponse;

  factory MyFollowingsResponse.fromJson(Map<String, Object?> json) => _$MyFollowingsResponseFromJson(json);
}
