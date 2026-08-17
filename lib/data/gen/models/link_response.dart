// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_response.freezed.dart';
part 'link_response.g.dart';

@Freezed()
abstract class LinkResponse with _$LinkResponse {
  const factory LinkResponse({
    required String linkName,
    required String link,
  }) = _LinkResponse;

  factory LinkResponse.fromJson(Map<String, Object?> json) => _$LinkResponseFromJson(json);
}
