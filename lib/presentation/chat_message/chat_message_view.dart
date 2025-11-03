import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_image_gallery.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_fragment.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';

class ChatMessageView extends ConsumerWidget {
  const ChatMessageView({
    super.key,
    required this.chatId,
    required this.drawerView,
    required this.appBarView,
    required this.fieldView,
  });

  final String chatId;
  final Widget drawerView;
  final PreferredSizeWidget appBarView;
  final Widget fieldView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatMessageProviderProvider(chatId: chatId).notifier);
    final data = ref.watch(chatMessageProviderProvider(chatId: chatId));

    return Scaffold(
      endDrawer: drawerView,
      appBar: appBarView,
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (data.isLoading) {
                  return Center(child: GrimityCircularProgressIndicator());
                }

                return Stack(
                  children: [
                    GrimityInfiniteScrollPagination(
                      isEnabled: data.value!.nextCursor != null,
                      onLoadMore: provider.loadMore,
                      reverse: true,
                      child: ListView.separated(
                        separatorBuilder: (_, _) => SizedBox(height: 10),
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: data.value!.messages.length,
                        itemBuilder: (context, index) {
                          final chatMessage = data.value!.messages[index];
                          final prevMessage =
                              index < data.value!.messages.length - 1 ? data.value!.messages[index + 1] : null;

                          bool showDateHeader = shouldShowDateHeader(
                            currentMessage: chatMessage,
                            prevMessage: prevMessage,
                          );

                          return Column(
                            children: [
                              if (showDateHeader)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    chatMessage.createdAt.toYearMonthDay,
                                    style: AppTypeface.label2.copyWith(color: AppColor.gray400),
                                  ),
                                ),
                              ChatMessageFragment(chatId: chatId, model: chatMessage),
                            ],
                          );
                        },
                      ),
                    ),

                    // 사용자가 선택한 이미지 목록 표시.
                    if (data.value!.inputImages.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomCenter,
                        // 이미 위치를 추적해야 하는 대상인 [ChatMessageField] 위젯에서
                        // [SafeArea] 위젯을 통해 대응했기 때문에 뷰 패딩 값을 모두 제거.
                        child: MediaQuery(
                          data: MediaQueryData(viewPadding: EdgeInsets.zero),
                          child: ChatMessageImageGallery(chatId: chatId),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          fieldView,
        ],
      ),
    );
  }

  // 채팅 메세지 리스트에서 날짜 헤더를 표시할 지 여부
  bool shouldShowDateHeader({required ChatMessage currentMessage, required ChatMessage? prevMessage}) {
    final currentDate = currentMessage.createdAt;
    final prevDate = prevMessage?.createdAt;

    // 첫 메세지이거나, 이전 메세지와 날짜가 다를 때만 true
    return prevDate == null || !prevDate.isSameDay(currentDate);
  }
}
