// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/chat/models/chat_model.dart';
import 'package:grimity/presentation/chat/services/chat_service.dart';
import 'package:grimity/presentation/chat/widgets/chat_app_bar.dart';
import 'package:grimity/presentation/chat/widgets/chat_input_bar.dart';
import 'package:grimity/presentation/chat/widgets/chat_message_item.dart';
import 'package:grimity/presentation/chat/widgets/chat_thumbnails.dart';
import 'package:pervice/pervice.dart';

/// 상대방과의 실시간 대화 내역과 메시지 입력창을 표시하는 DM 페이지.
class ChatPage extends StatelessWidget {
  const new({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final model = context.stateOf(ChatModel.new);

    // 현재 채팅방의 메시지 목록을 조회하는 서비스.
    final chatService = context.serviceOf(
      () => ChatService(id: id),
      key: ValueKey(id),
    );

    // 채팅 상대방 정보를 조회하는 서비스.
    final userService = context.serviceOf(
      () => GetChatsByIdUser(id: id),
      key: ValueKey(id),
    );

    return GdsScaffold(
      appBar: ChatAppBar(
        chatId: id,
        service: userService,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 메세지 목록 표시
                chatService.page(
                  loaded: (data) {
                    final messages = data.expand((e) => e.messages).toList();

                    // 주고받은 메시지가 없으면 빈 채팅방 안내를 표시.
                    if (messages.isEmpty) {
                      return GdsScrollable(
                        padding: 20.all,
                        child: GdsEmptyState(
                          illust: .illustReply,
                          title: '아직 주고 받은 메시지가 없어요',
                        ),
                      );
                    }

                    return GdsInfiniteScroll(
                      onLoadMore: chatService.loadMore,
                      enabled: chatService.canLoreMore,
                      reverse: true,
                      child: ListView.separated(
                        padding: 20.all,
                        reverse: true,
                        separatorBuilder: (_, _) => const Gap(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          // 메시지 작성 시각을 현지 날짜 문자열로 변환.
                          final date = message.createdAt.toLocal().yearMonthDay;

                          // 날짜 구분을 위해 시간상 이전 메시지의 현지 날짜 확인.
                          final previousDate = messages
                              .elementAtOrNull(index + 1) //
                              ?.createdAt
                              .toLocal()
                              .yearMonthDay;

                          return Column(
                            mainAxisSize: .min,
                            spacing: 10,
                            children: [
                              // 가장 오래된 메시지이거나 이전 메시지와 날짜가 다르면 날짜 표시.
                              if (date != previousDate) ...[
                                GdsText(
                                  date.replaceAll('-', '.'),
                                  color: .textGraySubtle,
                                  style: .label6,
                                ),
                              ],

                              ChatMessageItem(
                                service: userService,
                                message: message,
                                model: model,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),

                // 첨부된 이미지의 섬네일 목록 표시
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ChatThumbnails(model: model),
                ),
              ],
            ),
          ),

          // 제출 입력 필드 표시
          ChatInputBar(
            model: model,
            userService: userService,
            chatService: chatService,
          ),
        ],
      ),
    );
  }
}
