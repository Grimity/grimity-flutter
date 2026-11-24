// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/chat_list/pages/chat_list_page.dart';
import 'package:grimity/presentation/chat_new/screens/new_chat_screen.dart';
import 'package:pervice/pervice.dart';

/// 채팅 목록의 헤더 제목, 액션 버튼과 검색 필드를 표시하는 위젯.
class ChatListHeader extends StatelessWidget {
  const new({
    super.key,
    required this.service,
    required this.keyword,
    required this.mode,
  });

  final LoadMoreService<ChatsResponse> service;
  final ValueState<String> keyword;
  final ValueState<ChatListMode> mode;

  @override
  Widget build(BuildContext context) {
    final hasData = service.maybeData?.singleOrNull?.chats.isNotEmpty ?? false;

    return Padding(
      padding: context.whenDevice(
        mobile: 12.vertical + 20.horizontal,
        tablet: 16.vertical + 20.horizontal,
      ),
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          Row(
            spacing: 8,
            children: [
              // 헤더 제목 표시
              Expanded(
                child: GdsText(
                  'DM',
                  color: .textGrayBold,
                  style: context.whenDevice(
                    mobile: .title2,
                    tablet: .title1,
                  ),
                ),
              ),

              // 새 메시지 이동 버튼 표시
              GdsButton.text(
                type: .outlined,
                size: .sm,
                label: '새 메세지',
                onTap: () {
                  // 새 채팅 화면 열기.
                  const NewChatScreen().push(context);
                },
                enabled: mode.value == .none,
              ),

              // 편집 버튼 표시
              GdsButton.text(
                type: .outlined,
                size: .sm,
                label: '편집',
                onTap: () => mode.value = .edit,
                enabled: hasData && mode.value == .none,
              ),
            ],
          ),

          // 검색어 입력 필드 표시
          GdsTextField.search(
            size: .sm,
            placeholder: '작가 이름을 검색해보세요',
            initialText: keyword.value,
            onSubmitted: (value) => keyword.value = value.trim(),
            status: .from(enabled: hasData || keyword.isNotEmpty),
          ),
        ],
      ),
    );
  }
}
