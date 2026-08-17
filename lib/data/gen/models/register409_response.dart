// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'register409_response_message.dart';
import 'register409_response_status_code.dart';

part 'register409_response.freezed.dart';
part 'register409_response.g.dart';

@Freezed()
abstract class Register409Response with _$Register409Response {
  const factory Register409Response({
    required Register409ResponseStatusCode statusCode,
    required Register409ResponseMessage message,
  }) = _Register409Response;

  factory Register409Response.fromJson(Map<String, Object?> json) => _$Register409ResponseFromJson(json);
}
