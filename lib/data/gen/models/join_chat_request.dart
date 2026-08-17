// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_chat_request.freezed.dart';
part 'join_chat_request.g.dart';

@Freezed()
abstract class JoinChatRequest with _$JoinChatRequest {
  const factory JoinChatRequest({
    required String socketId,
  }) = _JoinChatRequest;

  factory JoinChatRequest.fromJson(Map<String, Object?> json) => _$JoinChatRequestFromJson(json);
}
