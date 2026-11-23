// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/chat_list/pages/chat_list_page.dart';
import 'package:pervice/pervice.dart';

/// 채팅 목록 편집 시 전체 선택, 채팅방 나가기와 취소 버튼을 표시하는 위젯.
class ChatListActions extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.selectedChats,
    required this.mode,
  });

  final LoadMoreService<ChatsResponse> service;
  final ValueState<List<ChatResponse>> selectedChats;
  final ValueState<ChatListMode> mode;

  @override
  Widget build(BuildContext context) {
    final chats = service.maybeData?.expand((e) => e.chats) ?? const [];

    // 모든 채팅이 선택되었는지 여부.
    final isSelectedAll = chats.length == selectedChats.length;

    return GdsFoldable.builder(
      alignment: .topCenter,
      visible: mode.value == .edit,
      axis: .vertical,
      builder: (context) {
        return GdsContainer(
          color: .bgPrimary,
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              // 전체 선택 버튼 표시
              GdsControl.label(
                control: GdsCheckBox(size: .md, value: isSelectedAll),
                label: '전체 선택',
                onTap: () {
                  isSelectedAll // 전체 해제하거나 선택.
                      ? selectedChats.clear()
                      : selectedChats.addAll(chats);
                },
              ),

              // 가로로 액션 버튼 표시
              Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [
                  // 채팅방 나가기 버튼 표시
                  GdsButton.text(
                    size: .md,
                    type: .borderless,
                    variant: .assistive,
                    enabled: selectedChats.isNotEmpty,
                    label: '채팅방 나가기',
                    onTap: () async {
                      final ids = selectedChats.value.builder((e) => e.id);

                      // 선택한 채팅방을 나간 뒤 목록 새로고침.
                      await PostChatsBatchDelete(request: .new(ids: ids)).request();

                      selectedChats.clear();
                      ChatListPage.refreshNotifier.notify();
                    },
                  ),

                  GdsDivider(
                    variant: .primary,
                    vertical: true,
                    extent: 16,
                  ),

                  // 편집 취소 버튼 표시
                  GdsButton.text(
                    size: .md,
                    type: .borderless,
                    variant: .assistive,
                    label: '아니요',
                    onTap: () {
                      // 선택한 채팅 전체를 모두 해제하고 편집 모드 종료.
                      selectedChats.clear();
                      mode.value = .none;
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
