import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_request_params.freezed.dart';
part 'chat_message_request_params.g.dart';

@freezed
abstract class SendChatMessageRequest with _$SendChatMessageRequest {
  const factory SendChatMessageRequest({
    required String chatId,
    required String content,
    required List<String> images,
    required String? replyToId,
  }) = _SendChatMessageRequest;

  factory SendChatMessageRequest.fromJson(Map<String, dynamic> json) => _$SendChatMessageRequestFromJson(json);
}
