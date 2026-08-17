// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'searched_user_response.freezed.dart';
part 'searched_user_response.g.dart';

@Freezed()
abstract class SearchedUserResponse with _$SearchedUserResponse {
  const factory SearchedUserResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,

    /// not null인데 공백은 허용
    required String description,
    required String? backgroundImage,
    required bool isFollowing,
    required num followerCount,
    required bool isBlocking,
    required bool isBlocked,
  }) = _SearchedUserResponse;

  factory SearchedUserResponse.fromJson(Map<String, Object?> json) => _$SearchedUserResponseFromJson(json);
}
