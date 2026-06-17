import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/chat_new/new_chat_view.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_drawer.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsScaffold(
      appBar: GrimityMainTopNavigation(),
      drawer: GrimityDrawer(),
      body: NewChatView(isModal: false),
    );
  }

  /// 새 메세지 페이지로 이동합니다.
  static Future<T?> push<T>(BuildContext context) {
    if (context.isMobile) {
      return NewChatRoute().push<T>(context);
    } else {
      final body = NewChatView(isModal: true);
      final modal = GdsModal(title: '새 메세지 보내기', body: body);

      return modal.open<T>(context);
    }
  }
}
