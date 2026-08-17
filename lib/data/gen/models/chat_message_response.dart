// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message_type.dart';
import 'reply_to_response.dart';
import 'user_base_response.dart';

part 'chat_message_response.freezed.dart';
part 'chat_message_response.g.dart';

@Freezed()
abstract class ChatMessageResponse with _$ChatMessageResponse {
  const factory ChatMessageResponse({
    required String id,
    required String? content,

    /// DEPRECATED: images[0]와 동일. images 사용 권장
    @Deprecated('This is marked as deprecated') required String? image,

    /// 메시지에 묶인 이미지들 (최대 5개, 없으면 빈 배열)
    required List<String> images,
    required DateTime createdAt,
    required UserBaseResponse user,
    required bool isLike,

    /// 메시지 타입 (USER: 일반, COMMISSION_*: 시스템 메시지)
    required ChatMessageType type,

    /// 시스템 메시지 클릭 시 이동 대상 ID (커미션 등). 일반 메시지는 null
    required String? referenceId,
    required ReplyToResponse? replyTo,
  }) = _ChatMessageResponse;

  factory ChatMessageResponse.fromJson(Map<String, Object?> json) => _$ChatMessageResponseFromJson(json);
}
