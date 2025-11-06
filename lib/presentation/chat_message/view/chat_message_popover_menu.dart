import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/ux/popover.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class ChatMessagePopoverMenu extends ConsumerWidget {
  const ChatMessagePopoverMenu({
    super.key,
    required this.chatId,
    required this.popover,
    required this.message,
  });

  final String chatId;
  final Popover popover;
  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatMessageProviderProvider(chatId: chatId).notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        createButtonWidget(
          icon: Assets.icons.chatMessage.heart,
          onTap: () {
            provider.likeMessage(message, !message.isLike);
            popover.hide();
          }
        ),
        createButtonWidget(
          icon: Assets.icons.chatMessage.deliver,
          onTap: () {
            provider.setInputReply(message);
            popover.hide();
          }
        ),
      ],
    );
  }

  Widget createButtonWidget({
    required SvgGenImage icon,
    required VoidCallback onTap,
  }) {
    return GrimityGesture(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.gray400),
          color: AppColor.gray00,
        ),
        child: icon.svg(width: 18, height: 18, color: AppColor.gray800),
      ),
    );
  }
}