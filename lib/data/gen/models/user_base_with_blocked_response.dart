// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_base_with_blocked_response.freezed.dart';
part 'user_base_with_blocked_response.g.dart';

@Freezed()
abstract class UserBaseWithBlockedResponse with _$UserBaseWithBlockedResponse {
  const factory UserBaseWithBlockedResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,

    /// 차단 여부
    required bool isBlocked,
  }) = _UserBaseWithBlockedResponse;

  factory UserBaseWithBlockedResponse.fromJson(Map<String, Object?> json) =>
      _$UserBaseWithBlockedResponseFromJson(json);
}
