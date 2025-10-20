import 'package:collection/collection.dart';
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
    required String inputMessage,
    required List<ImageSourceItem> inputImages,
    required ChatMessageReplyResponse? inputReply,
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
  late io.Socket _socket;

  // ignore: avoid_public_notifier_properties
  late TextEditingController inputMessageController;

  /// 한꺼번에 로드할 메시지의 최대 개수.
  static const int loadItemSize = 30;

  ChatMessageState get _state => state.value!;

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
      inputMessage: "",
      inputImages: [],
      inputReply: null,
      nextCursor: historyResponse.nextCursor,
      messages: historyResponse.messages.map(ChatMessage.fromItemResponse).toList(),
    );
  }

  void connectSocket() async {
    final token = await loadTokenUseCase.execute();
    late String socketId;

    _socket = io.io(
      Flavor.env.apiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'accessToken': token!.accessToken})
          .build(),
    );

    ref.onDispose(_socket.dispose);

    // 소켓 연결 시 채팅방에 대한 입장 상태를 서버에 알림.
    _socket.onConnect((_) {
      socketId = _socket.id!;
      getIt<ChatAPI>().join(chatId, SocketChatRequest(socketId: socketId));
    });

    // 연결 해제 시에도 채팅방에서 나갔다고 서버에게 알림.
    _socket.onDisconnect((_) {
      getIt<ChatAPI>().leave(chatId, SocketChatRequest(socketId: socketId));
    });

    // 새로운 메세지 이벤트.
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

    // 메세지 좋아요 이벤트.
    _socket.on('likeChatMessage', (data) {
      final message = findMessageById(data);

      // 기존 메세지 정보 업데이트.
      if (message != null) {
        updateMessageById(message.id, (m) => m.copyWith(isLike: true));
      }
    });

    // 메세지 좋아요 이벤트.
    _socket.on('unlikeChatMessage', (data) {
      final message = findMessageById(data);

      // 기존 메세지 정보 업데이트.
      if (message != null) {
        updateMessageById(message.id, (m) => m.copyWith(isLike: false));
      }
    });
  }

  void submit() async {
    final uploadImages = <ImageUploadUrl>[];

    // 사용자가 대상에게 보낼 메세지에 이미지를 포함시킨 경우.
    if (_state.inputImages.isNotEmpty) {
      uploadImages.addAll(await ImageUpload.uploadAssets(_state.inputImages, PresignedType.chat));
    }

    // 메세지 전송 시, 사용자 입력 필드 초기화.
    inputMessageController.text = "";

    await getIt<ChatMessageAPI>().sendMessage(
      SendChatMessageRequest(
        chatId: chatId,
        content: _state.inputMessage,
        images: uploadImages.map((e) => e.imageName).toList(),
        replyToId: _state.inputReply?.id,
      ),
    );

    state = AsyncData(_state.copyWith(
      inputMessage: "",
      inputImages: [],
      inputReply: null,
    ));
  }

  Future<void> loadMore() async {
    final response = await getIt<ChatMessageAPI>().getMessages(loadItemSize, _state.nextCursor, chatId);

    addMessages(response.messages.map(ChatMessage.fromItemResponse).toList());
    state = AsyncData(_state.copyWith(nextCursor: response.nextCursor));
  }

  void addInputImages(List<ImageSourceItem> newImages) {
    final currentImages = _state.inputImages;
    final maxImages = 5;

    // 이미 추가된 이미지가 5개로서 최대 갯수인 경우.
    if (currentImages.length >= maxImages) return;

    final availableSpace = maxImages - currentImages.length;
    final imagesToAdd = newImages.take(availableSpace).toList();

    state = AsyncData(_state.copyWith(
      inputImages: [...currentImages, ...imagesToAdd],
    ));
  }

  void removeInputImage(ImageSourceItem image) {
    state = AsyncData(_state.copyWith(
      inputImages: _state.inputImages.where((e) => e != image).toList(),
    ));
  }

  void setInputReply(ChatMessage message) {
    state = AsyncData(_state.copyWith(
      inputReply: ChatMessageReplyResponse(
        id: message.id,
        content: message.content,
        image: message.image,
        createdAt: message.createdAt,
      ),
    ));
  }

  void setInputMessage(String newMessage) {
    state = AsyncData(state.value!.copyWith(inputMessage: newMessage));
  }

  /// 새로운 메시지를 추가할 때, 증복되는 메시지가 없도록 하고 항상 최신 순으로 정렬되도록 보장합니다.
  void addMessages(List<ChatMessage> newMessages) {
    final prevIds = _state.messages.map((m) => m.id).toSet();
    final filtered = newMessages.where((m) => !prevIds.contains(m.id));
    final sorted = [..._state.messages, ...filtered]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = AsyncData(_state.copyWith(messages: sorted));
  }

  /// 주로 기존 메세지를 수정하기 위해서 사용됩니다.  
  void updateMessageById(String id, ChatMessage Function(ChatMessage) updater) {
    final updatedMessages = _state.messages.map((m) {
      return m.id == id ? updater(m) : m;
    }).toList();

    state = AsyncData(_state.copyWith(messages: updatedMessages));
  }

  ChatMessage? findMessageById(String id) {
    return state.value!.messages.firstWhereOrNull((e) => e.id == id);
  }

  Future<void> likeMessage(ChatMessage message, bool isLike) async {
    updateMessageById(message.id, (m) => m.copyWith(isLike: isLike));

    try {
      if (isLike) {
        await getIt<ChatMessageAPI>().likeMessage(message.id);
      } else {
        await getIt<ChatMessageAPI>().unlikeMessage(message.id);
      }
    } catch (e) {
      // 예외 발생 시 롤백.
      updateMessageById(message.id, (m) => m.copyWith(isLike: !isLike));
    }
  }
}
