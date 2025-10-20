import 'package:flutter/widgets.dart';
import 'package:grimity/presentation/chat_message/chat_message_view.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_app_bar.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_field.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';

class ChatMessagePage extends StatelessWidget {
  const ChatMessagePage({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return ChatMessageView(
      chatId: chatId,
      drawerView: MainAppDrawer(),
      appBarView: ChatMessageAppBar(chatId: chatId),
      fieldView: ChatMessageField(chatId: chatId),
    );
  }
}
