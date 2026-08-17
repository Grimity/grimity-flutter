// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'searched_user_response.dart';

part 'searched_users_response.freezed.dart';
part 'searched_users_response.g.dart';

@Freezed()
abstract class SearchedUsersResponse with _$SearchedUsersResponse {
  const factory SearchedUsersResponse({
    required String? nextCursor,
    required List<SearchedUserResponse> users,
  }) = _SearchedUsersResponse;

  factory SearchedUsersResponse.fromJson(Map<String, Object?> json) => _$SearchedUsersResponseFromJson(json);
}
