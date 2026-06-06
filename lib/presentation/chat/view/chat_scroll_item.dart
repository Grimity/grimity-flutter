import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/data/model/chat/chat_response.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatScrollItem extends ConsumerWidget {
  const ChatScrollItem({super.key, required this.model});

  final ChatResponse model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final isSelected = provider.hasSelected(model);
    final isSelectMode = data.value?.isSelectMode ?? false;

    return GdsDmItem(
      nickname: model.opponentUser.name,
      messageText: model.lastMessage == null ? '최근 메세지가 없습니다.' : model.lastMessage?.content ?? '사진을 보냈습니다.',
      avatarImageUrl: model.opponentUser.image ?? '',
      timeText: model.enteredAt.toRelativeTime(),
      unreadCount: model.unreadCount,
      showCheckbox: isSelectMode,
      isChecked: isSelected,
      onCheckboxTap: () => provider.selectChat(model, !isSelected),
      onTap: () {
        if (isSelectMode) {
          provider.selectChat(model, !isSelected);
          return;
        }

        // 해당 채팅방 페이지로 이동.
        ChatMessageRoute(model.id).push(context);
      },
    );
  }
}
