import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/image/Image_upload.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/data/data_source/remote/chat_message_api.dart';
import 'package:grimity/data/model/chat_message/chat_message_item_response.dart';
import 'package:grimity/data/model/chat_message/chat_message_reply_response.dart';
import 'package:grimity/data/model/chat_message/chat_message_response.dart';
import 'package:grimity/data/model/chat_message/chat_message_socket_response.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/domain/dto/chat_message_request_params.dart';
import 'package:grimity/domain/dto/chat_request_params.dart';
import 'package:grimity/domain/entity/image_upload_url.dart';
import 'package:grimity/domain/usecase/auth_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'chat_message_provider.freezed.dart';
part 'chat_message_provider.g.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String? content,
    required String? image,
    required DateTime createdAt,
    required String userId,
    required bool isLike,
    required ChatMessageReplyResponse? replyTo,
  }) = _ChatMessage;

  static ChatMessage fromItemResponse(ChatMessageItemResponse response) {
    return ChatMessage(
      id: response.id,
      content: response.content,
      image: response.image,
      createdAt: response.createdAt,
      userId: response.user.id,
      isLike: response.isLike,
      replyTo: response.replyTo
    );
  }
}

@freezed
abstract class ChatMessageState with _$ChatMessageState {
  const factory ChatMessageState({
    required UserBaseResponse opponentUser,
    required String? inputReplyToId,
    required String inputMessage,
    required List<ImageSourceItem> inputImages,
    required List<ChatMessage> messages,
    required String? nextCursor,
  }) = _ChatMessageState;
}

extension ChatMessageStateExtension on ChatMessageState {
  /// 현재 메세지를 대상에게 보낼 수 있는지에 대한 여부.
  bool get canSubmit => inputImages.isNotEmpty || inputMessage.trim().isNotEmpty;
}

@riverpod
class ChatMessageProvider extends _$ChatMessageProvider {
  late final io.Socket _socket;

  // ignore: avoid_public_notifier_properties
  late TextEditingController inputMessageController;

  /// 한꺼번에 로드할 메시지의 최대 개수.
  static const int loadItemSize = 30;

  @override
  FutureOr<ChatMessageState> build({required String chatId}) async {
    final responses = await Future.wait([
      getIt<ChatAPI>().getUserByChat(chatId),
      getIt<ChatMessageAPI>().getMessages(loadItemSize, null, chatId),
    ]);

    connectSocket();

    final historyResponse = responses[1] as ChatMessageResponse;

    return ChatMessageState(
      opponentUser: responses[0] as UserBaseResponse,
      inputReplyToId: null,
      inputMessage: "",
      inputImages: [],
      nextCursor: historyResponse.nextCursor,
      messages: historyResponse.messages.map(ChatMessage.fromItemResponse).toList(),
    );
  }

  void connectSocket() async {
    final token = await loadTokenUseCase.execute();

    _socket = io.io(
      Flavor.env.apiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'accessToken': token!.accessToken})
          .build(),
    );

    SocketChatRequest socketIdRequest() {
      return SocketChatRequest(socketId: _socket.id!);
    }

    // 소켓 연결 시 항상 채팅방에 대한 입장 상태를 서버에 알리고,
    // 연결 해제 시에도 자동으로 채팅방에서 나갔다고 서버에게 알림.
    _socket.onConnect((_) => getIt<ChatAPI>().join(chatId, socketIdRequest()));
    _socket.onDisconnect((_) => getIt<ChatAPI>().leave(chatId, socketIdRequest()));

    _socket.on('newChatMessage', (data) {
      final response = ChatMessageSocketResponse.fromJson(data);
      final messages = response.messages.map((message) {
        return ChatMessage(
          id: message.id,
          content: message.content,
          image: message.image,
          createdAt: message.createdAt,
          userId: response.senderId,
          isLike: false,
          replyTo: message.replyTo,
        );
      });

      addMessages(messages.toList());
    });
  }

  void submit() async {
    final self = state.value!;
    final uploadImages = <ImageUploadUrl>[];

    // 사용자가 대상에게 보낼 메세지에 이미지를 포함시킨 경우.
    if (self.inputImages.isNotEmpty) {
      uploadImages.addAll(await ImageUpload.uploadAssets(self.inputImages, PresignedType.chat));
    }

    // 메세지 전송 시, 사용자 입력 필드 초기화.
    inputMessageController.text = "";

    await getIt<ChatMessageAPI>().sendMessage(
      SendChatMessageRequest(
        chatId: chatId,
        content: self.inputMessage,
        images: uploadImages.map((e) => e.imageName).toList(),
        replyToId: self.inputReplyToId,
      ),
    );

    state = AsyncData(state.value!.copyWith(
      inputReplyToId: null,
      inputMessage: "",
      inputImages: [],
    ));
  }

  Future<void> loadMore() async {
    final self = state.value!;
    final response = await getIt<ChatMessageAPI>().getMessages(loadItemSize, self.nextCursor, chatId);

    addMessages(response.messages.map(ChatMessage.fromItemResponse).toList());
  }

  void addInputImages(List<ImageSourceItem> newImages) {
    final currentImages = state.value!.inputImages;
    final maxImages = 5;

    // 이미 추가된 이미지가 5개로서 최대 갯수인 경우.
    if (currentImages.length >= maxImages) return;

    final availableSpace = maxImages - currentImages.length;
    final imagesToAdd = newImages.take(availableSpace).toList();

    state = AsyncData(state.value!.copyWith(
      inputImages: [...currentImages, ...imagesToAdd],
    ));
  }

  void setInputMessage(String newMessage) {
    state = AsyncData(state.value!.copyWith(inputMessage: newMessage));
  }

  /// 새로운 메시지를 추가할 때, 증복되는 메시지가 없도록 하고 항상 최신 순으로 정렬되도록 보장합니다.
  void addMessages(List<ChatMessage> newMessages) {
    final self = state.value!;
    final prevIds = self.messages.map((m) => m.id).toSet();
    final filtered = newMessages.where((m) => !prevIds.contains(m.id));
    final sorted = [...self.messages, ...filtered]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = AsyncData(self.copyWith(messages: sorted));
  }

  /// 주로 기존 메세지를 수정하기 위해서 사용됩니다.  
  void updateMessage(ChatMessage newMessage) {

  }
}
