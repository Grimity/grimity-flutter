// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_request.freezed.dart';
part 'create_chat_request.g.dart';

@Freezed()
abstract class CreateChatRequest with _$CreateChatRequest {
  const factory CreateChatRequest({
    required String targetUserId,
  }) = _CreateChatRequest;

  factory CreateChatRequest.fromJson(Map<String, Object?> json) => _$CreateChatRequestFromJson(json);
}
