import 'package:flutter/material.dart';
import 'package:grimity/presentation/chat/view/chat_tool_bar.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/chat/chat_view.dart';
import 'package:grimity/presentation/chat/view/chat_app_bar.dart';
import 'package:grimity/presentation/chat/view/chat_search_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatView(
      drawerView: MainAppDrawer(),
      appbarView: ChatAppBar(),
      toolBarView: ChatToolBar(),
      searchBarView: ChatSearchBar(),
    );
  }
}
