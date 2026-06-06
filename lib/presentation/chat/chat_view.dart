import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_appbar/flutter_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/static/push_notification.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/chat/view/chat_scroll_item.dart';
import 'package:grimity/presentation/chat_new/new_chat_page.dart';
import 'package:grimity/presentation/common/widget/grimity_refresh_indicator.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({
    super.key,
    required this.appbarView,
    required this.toolBarView,
    required this.searchBarView,
  });

  final Widget appbarView;
  final Widget toolBarView;
  final Widget searchBarView;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final _visibilityKey = UniqueKey();
  StreamSubscription? _subscription;

  /// 채팅 페이지에서 타이틀과 검색 바 앱배의 동작
  static AppBarBehavior appBarBehavior = MaterialAppBarBehavior(floating: true, alwaysScrolling: false);

  void onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction > 0;

    if (!isVisible) {
      _subscription?.cancel();
      _subscription = null;
    }

    // 새 메세지가 전송된 경우, 채팅 목록 새로고침.
    _subscription ??= PushNotification.stream.listen((message) {
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
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: onVisibilityChanged,
      child: GdsScaffold(
        appBar: GrimityMainTopNavigation(),
        body: Consumer(
          builder: (context, ref, _) {
            final provider = ref.read(chatProviderProvider.notifier);
            final data = ref.watch(chatProviderProvider);
            final isSelectMode = data.value?.isSelectMode ?? false;

            // 현재 데이터를 불러오고 있는 경우.
            if (data.isLoading) {
              return Center(child: GdsCircularLoading());
            }

            final Widget child;

            // 현재 주고 받은 메세지가 아직 없는 경우.
            if (data.value!.chats.isEmpty && data.value!.keyword == null) {
              child = SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing16),
                child: GdsEmptyState(
                  title: '아직 주고 받은 메세지가 없어요',
                  description: '다른 작가에게 사진과 메세지를\n보낼 수 있어요',
                  size: GdsEmptyStateSize.md,
                  icon: GdsIcon.reply,
                  action: GdsOutlinedButton(
                    text: '새 메세지 보내기',
                    onPressed: () => NewChatPage.push(context),
                  ),
                ),
              );
            } else {
              child = Column(
                children: [
                  if (isSelectMode) widget.toolBarView,

                  Expanded(
                    child: GrimityRefreshIndicator(
                      onRefresh: provider.refresh,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          top: isSelectMode ? 0 : GdsSpacing.spacing16,
                          left: GdsSpacing.spacing20,
                          right: GdsSpacing.spacing20,
                          bottom: GdsSpacing.spacing16,
                        ),
                        itemCount: data.value!.chats.length,
                        itemBuilder: (context, index) {
                          return ChatScrollItem(model: data.value!.chats[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return AppBarConnection(
              appBars: [
                AppBar(behavior: appBarBehavior, body: widget.appbarView),
                AppBar(behavior: appBarBehavior, body: widget.searchBarView),
              ],
              child: child,
            );
          },
        ),
      ),
    );
  }
}
