// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'insert_feeds_request.freezed.dart';
part 'insert_feeds_request.g.dart';

@Freezed()
abstract class InsertFeedsRequest with _$InsertFeedsRequest {
  const factory InsertFeedsRequest({
    required List<String> ids,
  }) = _InsertFeedsRequest;

  factory InsertFeedsRequest.fromJson(Map<String, Object?> json) => _$InsertFeedsRequestFromJson(json);
}
