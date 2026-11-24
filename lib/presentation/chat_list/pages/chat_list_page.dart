// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/chat/pages/chat_page.dart';
import 'package:grimity/presentation/chat_list/services/chat_list_service.dart';
import 'package:grimity/presentation/chat_list/widgets/chat_list_actions.dart';
import 'package:grimity/presentation/chat_list/widgets/chat_list_header.dart';
import 'package:grimity/presentation/chat_new/screens/new_chat_screen.dart';
import 'package:grimity/presentation/navigation/navigation_view.dart';
import 'package:grimity/widgets/sliver_scroll_view.dart';
import 'package:pervice/pervice.dart';

/// 채팅 목록의 기본 및 편집 상태를 나타내는 열거형.
enum ChatListMode {
  none,
  edit,
}

/// 채팅 목록을 조회하고 검색 및 편집 기능을 제공하는 페이지.
class ChatListPage extends StatelessWidget with NavigationView {
  const new({super.key});

  @override
  GdsIcon get icon => .message;

  @override
  String get label => 'DM';

  @override
  bool get showDot => profile.hasUnreadChatMessage;

  /// 채팅 목록 새로고침을 요청하는 알림.
  static final refreshNotifier = Notifier();

  /// 채팅 목록을 불러오는 동안 표시할 임시 데이터.
  static final placeholder = [
    ChatsResponse(
      chats: List.generate(5, (_) {
        return ChatResponse(
          id: '',
          unreadCount: 0,
          enteredAt: .now(),
          opponentUser: const .new(
            id: '',
            name: 'Placeholder',
            url: '',
          ),
          lastMessage: .new(
            id: '',
            content: 'Placeholder',
            images: const [],
            createdAt: .now(),
            senderId: '',
          ),
        );
      }),
    ),
  ];

  /// 검색어에 맞는 채팅 목록을 조회하는 서비스를 생성합니다.
  static ChatListService createService(String keyword) {
    return .new(keyword: keyword, listenable: refreshNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final keyword = context.stateOf(() => '');
    final mode = context.stateOf(() => ChatListMode.none);

    // 편집 모드에서 선택한 채팅 목록.
    final selectedChats = context.stateOf<List<ChatResponse>>(() => []);

    // 검색어를 기준으로 채팅 목록 서비스 관리.
    final service = context.serviceOf(
      () => createService(keyword.value),
      key: ValueKey(keyword.value),
    );

    return AppBarConnection(
      appBars: [
        AppBar(
          behavior: const MaterialAppBarBehavior(floating: true),
          body: ChatListHeader(
            service: service,
            keyword: keyword,
            mode: mode,
          ),
        ),
      ],
      child: GdsInfiniteScroll(
        onLoadMore: service.loadMore,
        enabled: service.canLoreMore,
        child: SliverScrollView(
          padding: context.whenDevice(
            mobile: 12.top + 20.horizontal,
            tablet: 8.top + 20.horizontal,
          ),
          slivers: [
            // 편집 모드에 대한 액션 버튼 고정 표시
            PinnedHeaderSliver(
              child: ChatListActions(
                service: service,
                selectedChats: selectedChats,
                mode: mode,
              ),
            ),

            // 알림 목록 표시
            service.sliver(
              placeholder: placeholder,
              builder: (data) {
                final chats = data.expand((e) => e.chats).toList();

                // 채팅이 아예 없을 경우.
                if (chats.isEmpty) {
                  return SliverToBoxAdapter(
                    child: GdsEmptyState(
                      illust: .illustReply,
                      title: '아직 주고 받은 메시지가 없어요',
                      description: '다른 작가에게 사진과 메시지를\n보낼 수 있어요',
                      action: .new(
                        type: .outlined,
                        label: '새 메세지 보내기',
                        onTap: () {
                          // 새 채팅 화면 열기.
                          const NewChatScreen().push(context);
                        },
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final user = chat.opponentUser;
                    final lastMessage = chat.lastMessage;
                    final isSelected = selectedChats.value.contains(chat);

                    // 채팅 항목에 표시할 최근 메시지 미리보기.
                    final preview = lastMessage == null
                        ? '최근 메시지가 없어요' //
                        : lastMessage.content ?? '사진을 보냈어요';

                    return GdsControl.foldable(
                      visible: mode.value == .edit,
                      spacing: 12,
                      control: GdsCheckBox(size: .md, value: isSelected),
                      onTap: () {
                        isSelected
                            ? selectedChats.remove(chat) //
                            : selectedChats.add(chat);
                      },
                      child: GdsDmList(
                        profile: user.image?.toImage(),
                        nickname: user.name,
                        message: preview,
                        createdAt: chat.enteredAt,
                        unreadCount: chat.unreadCount.toInt(),
                        onTap: () {
                          // 채팅방 페이지로 이동.
                          context.push(ChatPage(id: chat.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
