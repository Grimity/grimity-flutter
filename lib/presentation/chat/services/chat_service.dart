// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'dart:async';

import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_secure_storage.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/network/app_network.dart';
import 'package:grimity/presentation/chat/models/new_chat_message_payload.dart';
import 'package:grimity/presentation/chat_list/pages/chat_list_page.dart';
import 'package:socket_io_client/socket_io_client.dart';

/// 채팅 메시지를 조회하고 실시간 채팅방 연결을 관리하는 서비스.
class ChatService extends LoadMoreService<ChatMessagesResponse> {
  new({required this.id})
    : super(
        builder: (cursor) => GetChatMessages(
          cursor: cursor,
          chatId: id,
          size: 20,
        ),
        cursorOf: (data) => data.nextCursor,
      );

  final String id;

  /// 채팅방의 실시간 통신에 사용하는 소켓.
  Socket? socket;
  String? socketId;

  @override
  Future<void> load({bool isRefresh = false}) async {
    await super.load(isRefresh: isRefresh);

    // 첫 메시지 목록을 불러온 뒤 실시간 채팅방에 연결.
    if (!isRefresh && socket == null) {
      await connect();
    }
  }

  /// 소켓을 연결하고 채팅방의 실시간 이벤트를 구독합니다.
  Future<void> connect() async {
    final token = await AppSecureStorage.accessToken.get();
    if (token == null) {
      throw StateError('채팅에 연결하려면 액세스 토큰이 필요합니다.');
    }

    // WebSocket 방식으로 연결하고 인증 토큰을 전달하며
    // 매번 새 소켓을 생성하여 기존 연결을 재사용하지 않도록 설정.
    final newSocket = io(
      AppNetwork.dio.options.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'accessToken': token})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket = newSocket;
    newSocket.onConnect(join);
    newSocket.onDisconnect(leave);

    // 새 메시지와 메시지 좋아요 상태 변경 이벤트를 구독.
    newSocket.on('newChatMessage', onNewChatMessage);
    newSocket.on('likeChatMessage', onLikeChatMessage);
    newSocket.on('unlikeChatMessage', onUnlikeChatMessage);

    newSocket.connect();
  }

  /// 현재 소켓을 채팅방에 입장시키고 읽음 상태를 갱신합니다.
  Future<void> join(dynamic _) async {
    await PutChatsByIdJoin(
      id: id,
      request: .new(socketId: socketId = socket!.id!),
    ).request();

    // 입장하면 읽지 않은 메시지 수도 초기화되므로 관련 상태를 갱신.
    await refreshChatState();
  }

  /// 연결이 끊긴 소켓의 채팅방 입장 상태를 해제합니다.
  Future<void> leave(dynamic _) async {
    await PutChatsByIdLeave(
      id: id,
      request: .new(socketId: socketId!),
    ).request();
  }

  /// 소켓으로 받은 새 메시지를 목록에 추가하고 상태를 갱신합니다.
  void onNewChatMessage(dynamic event) {
    final payload = NewChatMessagePayload.decode(event);
    final response = payload.toResponse();

    data.first.messages.insertAll(0, response);
    notifyChanged();
    refreshChatState();
  }

  /// 소켓 이벤트를 받아 해당 메시지를 좋아요 상태로 변경합니다.
  void onLikeChatMessage(dynamic event) {
    return setLike(event as String, true);
  }

  /// 소켓 이벤트를 받아 해당 메시지의 좋아요를 해제합니다.
  void onUnlikeChatMessage(dynamic event) {
    return setLike(event as String, false);
  }

  /// 해당 메시지가 로드되어 있을때만 좋아요 상태를 변경합니다.
  void setLike(String messageId, bool isLike) {
    for (final page in data) {
      final messages = page.messages;
      final index = messages.indexWhere((e) => e.id == messageId);
      if (index == -1) continue;

      messages[index] = messages[index].copyWith(isLike: isLike);
      notifyChanged();
      return;
    }
  }

  /// 메세지와 첨부 이미지를 채팅방에 전송합니다.
  Future<void> sendMessage({
    String? content,
    List<String> images = const [],
    String? replyToId,
  }) async {
    await PostChatMessages(
      request: .new(
        chatId: id,
        content: content,
        images: images,
        replyToId: replyToId,
      ),
    ).request();
  }

  /// 채팅 목록과 전역 읽지 않은 메시지 표시를 다시 불러옵니다.
  Future<void> refreshChatState() async {
    ChatListPage.refreshNotifier.notify();
    await AppUser.refresh();
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }
}
