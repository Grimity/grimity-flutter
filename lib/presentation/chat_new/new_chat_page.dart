import 'package:flutter/material.dart';
import 'package:grimity/presentation/chat_new/new_chat_view.dart';
import 'package:grimity/presentation/chat_new/view/new_chat_app_bar.dart';
import 'package:grimity/presentation/chat_new/view/new_chat_search_bar.dart';
import 'package:grimity/presentation/chat_new/view/new_chat_submit_button.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NewChatView(
      appBarView: NewChatAppBar(),
      searchBarView: NewChatSearchBar(),
      sibmitButtonView: NewChatSubmitButton(),
    );
  }
}
