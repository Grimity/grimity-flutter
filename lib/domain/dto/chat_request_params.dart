import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_request_params.freezed.dart';
part 'chat_request_params.g.dart';

@freezed
abstract class CreateChatRequest with _$CreateChatRequest {
  const factory CreateChatRequest({required String targetUserId}) = _CreateChatRequest;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) => _$CreateChatRequestFromJson(json);
}

@freezed
abstract class BatchDeleteChatRequest with _$BatchDeleteChatRequest {
  const factory BatchDeleteChatRequest({required List<String> ids}) = _BatchDeleteChatRequest;

  factory BatchDeleteChatRequest.fromJson(Map<String, dynamic> json) => _$BatchDeleteChatRequestFromJson(json);
}

@freezed
abstract class SocketChatRequest with _$SocketChatRequest {
  const factory SocketChatRequest({required String socketId}) = _SocketChatRequest;

  factory SocketChatRequest.fromJson(Map<String, dynamic> json) => _$SocketChatRequestFromJson(json);
}
