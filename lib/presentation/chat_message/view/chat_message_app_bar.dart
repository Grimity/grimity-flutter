import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/presentation/chat_message/components/show_delete_chat_dialog.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/report/report_page.dart';

class ChatMessageAppBar extends ConsumerWidget {
  const ChatMessageAppBar({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chatMessageProviderProvider(chatId: chatId));
    final state = data.value;

    return GdsTopNavigation.dm(
      userId: data.isLoading ? '' : '@${state!.opponentUser.url}',
      displayName: data.isLoading ? '' : state!.opponentUser.name,
      avatarImageUrl: data.isLoading ? '' : state!.opponentUser.image,
      onBack: () => context.pop(),
      onReport: () {
        // 신고 페이지로 이동.
        ReportPage.push(context, refType: ReportRefType.chat, refId: chatId);
      },
      onSignOut: () => showDeleteChatDialog(context: context, chatId: chatId),
      onProfile: () {
        final profileUrl = state?.opponentUser.url;
        if (profileUrl == null || profileUrl.isEmpty) return;

        ProfileRoute(url: profileUrl).push(context);
      },
    );
  }
}
