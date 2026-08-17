// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'opponent_user_response.freezed.dart';
part 'opponent_user_response.g.dart';

@Freezed()
abstract class OpponentUserResponse with _$OpponentUserResponse {
  const factory OpponentUserResponse({
    required String id,
    required String name,
    required String? image,

    /// 라우팅용 url
    required String url,
    required bool isBlocked,
    required bool isBlocking,
  }) = _OpponentUserResponse;

  factory OpponentUserResponse.fromJson(Map<String, Object?> json) => _$OpponentUserResponseFromJson(json);
}
