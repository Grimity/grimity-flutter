// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_chat_request.freezed.dart';
part 'leave_chat_request.g.dart';

@Freezed()
abstract class LeaveChatRequest with _$LeaveChatRequest {
  const factory LeaveChatRequest({
    required String socketId,
  }) = _LeaveChatRequest;

  factory LeaveChatRequest.fromJson(Map<String, Object?> json) => _$LeaveChatRequestFromJson(json);
}
