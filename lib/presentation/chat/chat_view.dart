import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/chat/view/chat_empty_view.dart';
import 'package:grimity/presentation/chat/view/chat_scroll_item.dart';
import 'package:grimity/presentation/chat/widgets/chat_floating_action_button.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.drawerView,
    required this.appbarView,
    required this.toolBarView,
    required this.searchBarView,
  });

  final Widget drawerView;
  final PreferredSizeWidget appbarView;
  final Widget toolBarView;
  final Widget searchBarView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawerView,
      appBar: appbarView,
      body: Consumer(
        builder: (context, ref, _) {
          final provider = ref.read(chatProviderProvider.notifier);
          final data = ref.watch(chatProviderProvider);

          // 현재 데이터를 불러오고 있는 경우.
          if (data.isLoading) {
            return Center(
              child: GrimityCircularProgressIndicator(),
            );
          }

          // 현재 주고 받은 메세지가 아직 없는 경우.
          if (data.value!.chats.isEmpty
           && data.value!.keyword == "") {
            return ListView(children: [ChatEmptyView()]);
          }

          return Stack(
            children: [
              Column(
                spacing: 16,
                children: [
                  searchBarView,
                  toolBarView,
                  Expanded(
                    child: GrimityRefreshIndicator(
                      onRefresh: provider.refresh,
                      child: ListView(
                        padding: EdgeInsets.all(16),
                        children: [
                          // 대화 기록이 존재하는 사용자 목록.
                          ...data.value!.chats.map((model) => ChatScrollItem(model: model)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 오른쪽 하단 액션 버튼 표시.
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16, bottom: 16),
                  child: ChatFloatingActionButton(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
