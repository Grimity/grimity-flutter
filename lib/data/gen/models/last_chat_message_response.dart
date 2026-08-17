// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_chat_message_response.freezed.dart';
part 'last_chat_message_response.g.dart';

@Freezed()
abstract class LastChatMessageResponse with _$LastChatMessageResponse {
  const factory LastChatMessageResponse({
    required String id,
    required String? content,

    /// DEPRECATED: images[0]와 동일. images 사용 권장
    @Deprecated('This is marked as deprecated') required String? image,

    /// 메시지에 묶인 이미지들 (최대 5개, 없으면 빈 배열)
    required List<String> images,
    required DateTime createdAt,

    /// 보낸 사람의 ID (마지막 채팅을 내가 보냈을수도잇음)
    required String senderId,
  }) = _LastChatMessageResponse;

  factory LastChatMessageResponse.fromJson(Map<String, Object?> json) => _$LastChatMessageResponseFromJson(json);
}
