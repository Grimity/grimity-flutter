// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_feeds_request.freezed.dart';
part 'delete_feeds_request.g.dart';

@Freezed()
abstract class DeleteFeedsRequest with _$DeleteFeedsRequest {
  const factory DeleteFeedsRequest({
    required List<String> ids,
  }) = _DeleteFeedsRequest;

  factory DeleteFeedsRequest.fromJson(Map<String, Object?> json) => _$DeleteFeedsRequestFromJson(json);
}
