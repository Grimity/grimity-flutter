import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/static/push_notification.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/chat/view/chat_scroll_item.dart';
import 'package:grimity/presentation/chat/widgets/chat_floating_action_button.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';

class ChatView extends ConsumerStatefulWidget {
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
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    // 새 메세지가 전송된 경우, 채팅 목록 새로고침.
    _subscription = PushNotification.stream.listen((message) {
      ref.read(chatProviderProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: widget.drawerView,
      appBar: widget.appbarView,
      body: Consumer(
        builder: (context, ref, _) {
          final provider = ref.read(chatProviderProvider.notifier);
          final data = ref.watch(chatProviderProvider);

          // 현재 데이터를 불러오고 있는 경우.
          if (data.isLoading) {
            return Center(child: GrimityCircularProgressIndicator());
          }

          // 현재 주고 받은 메세지가 아직 없는 경우.
          if (data.value!.chats.isEmpty && data.value!.keyword == null) {
            return ListView(
              children: [
                GrimityStateView.commentReply(
                  title: "주고 받은 메세지가 없어요",
                  subTitle: "팔로우 한 작가에게 메세지를 보내보세요",
                  buttonText: "새 메세지 보내기",
                  onTap: () => NewChatRoute().push(context),
                ),
              ],
            );
          }

          return Stack(
            children: [
              Column(
                spacing: 16,
                children: [
                  widget.searchBarView,
                  widget.toolBarView,
                  Expanded(
                    child: GrimityRefreshIndicator(
                      onRefresh: provider.refresh,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        padding: EdgeInsets.all(16),
                        itemCount: data.value!.chats.length,
                        itemBuilder: (context, index) {
                          return ChatScrollItem(model: data.value!.chats[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // 오른쪽 하단 액션 버튼 표시.
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(padding: EdgeInsets.only(right: 16, bottom: 16), child: ChatFloatingActionButton()),
              ),
            ],
          );
        },
      ),
    );
  }
}
