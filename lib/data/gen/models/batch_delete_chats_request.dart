// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_delete_chats_request.freezed.dart';
part 'batch_delete_chats_request.g.dart';

@Freezed()
abstract class BatchDeleteChatsRequest with _$BatchDeleteChatsRequest {
  const factory BatchDeleteChatsRequest({
    required List<String> ids,
  }) = _BatchDeleteChatsRequest;

  factory BatchDeleteChatsRequest.fromJson(Map<String, Object?> json) => _$BatchDeleteChatsRequestFromJson(json);
}
