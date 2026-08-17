// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_base_response.dart';

part 'my_blockings_response.freezed.dart';
part 'my_blockings_response.g.dart';

@Freezed()
abstract class MyBlockingsResponse with _$MyBlockingsResponse {
  const factory MyBlockingsResponse({
    required List<UserBaseResponse> users,
  }) = _MyBlockingsResponse;

  factory MyBlockingsResponse.fromJson(Map<String, Object?> json) => _$MyBlockingsResponseFromJson(json);
}
