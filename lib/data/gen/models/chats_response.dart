// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_response.dart';

part 'chats_response.freezed.dart';
part 'chats_response.g.dart';

@Freezed()
abstract class ChatsResponse with _$ChatsResponse {
  const factory ChatsResponse({
    required String? nextCursor,
    required List<ChatResponse> chats,
  }) = _ChatsResponse;

  factory ChatsResponse.fromJson(Map<String, Object?> json) => _$ChatsResponseFromJson(json);
}
