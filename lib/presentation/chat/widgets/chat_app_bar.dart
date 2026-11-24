// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/chat_list/pages/chat_list_page.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';
import 'package:grimity/presentation/report/screens/report_screen.dart';
import 'package:grimity/views/show_confirm_alert.dart';

/// 채팅 상대의 사용자 정보와 채팅방 액션 버튼을 표시하는 앱 바.
class ChatAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.chatId,
    required this.service,
  });

  final String chatId;
  final GetChatsByIdUser service;

  /// 상대방 정보를 불러오는 동안 표시할 임시 데이터.
  static const placeholder = OpponentUserResponse(
    id: '',
    name: 'Placeholder',
    image: '',
    url: 'Placeholder',
    isBlocked: false,
    isBlocking: false,
  );

  @override
  Widget build(BuildContext context) {
    return service.builder(
      placeholder: placeholder,
      builder: (data) {
        return GdsTopNavigation.dm(
          onBack: context.pop,
          onUser: () {
            // 상대방의 프로필 페이지로 이동.
            context.push(ProfilePage(url: data.url));
          },
          onExit: () async {
            final isConfirmed = await showConfirmAlert(
              context,
              label: '나가기',
              title: '채팅방을 나가시겠어요?',
              description: '지금까지 대화한 내용이 모두 사라지고\n복구가 불가능합니다.',
            );

            // 사용자가 채팅방 나가기를 동의했을 경우.
            if (isConfirmed == true) {
              await DeleteChatsById(id: chatId).request();

              // 채팅방을 닫고 채팅 목록 갱신.
              if (context.mounted) {
                context.pop();
                ChatListPage.refreshNotifier.notify();
              }
            }
          },
          onReport: () {
            // 채팅방 신고 화면으로 이동.
            ReportScreen(refId: data.id, refType: .chat).push(context);
          },
          nickname: data.name,
          handle: data.url,
          profile: data.image?.toImage(),
        );
      },
    );
  }
}
