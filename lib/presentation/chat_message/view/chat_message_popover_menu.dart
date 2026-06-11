import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/ux/popover.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';

class ChatMessagePopoverMenu extends ConsumerWidget {
  const ChatMessagePopoverMenu({super.key, required this.chatId, required this.popover, required this.message});

  final String chatId;
  final Popover popover;
  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatMessageProviderProvider(chatId: chatId).notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: GdsSpacing.spacing6,
      children: [
        GdsIconButton.outlined(
          icon: GdsHeart.icon(message.isLike),
          onPressed: () {
            provider.likeMessage(message, !message.isLike);
            popover.hide();
          },
        ),
        GdsIconButton.outlined(
          icon: GdsIcon.forward2,
          onPressed: () {
            provider.setInputReply(message);
            popover.hide();
          },
        ),
      ],
    );
  }
}
