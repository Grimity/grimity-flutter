// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'id_response.freezed.dart';
part 'id_response.g.dart';

@Freezed()
abstract class IdResponse with _$IdResponse {
  const factory IdResponse({
    required String id,
  }) = _IdResponse;

  factory IdResponse.fromJson(Map<String, Object?> json) => _$IdResponseFromJson(json);
}
