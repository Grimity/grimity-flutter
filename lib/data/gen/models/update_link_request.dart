// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_link_request.freezed.dart';
part 'update_link_request.g.dart';

@Freezed()
abstract class UpdateLinkRequest with _$UpdateLinkRequest {
  const factory UpdateLinkRequest({
    required String linkName,
    required String link,
  }) = _UpdateLinkRequest;

  factory UpdateLinkRequest.fromJson(Map<String, Object?> json) => _$UpdateLinkRequestFromJson(json);
}
