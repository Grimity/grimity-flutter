import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll_pagination/flutter_infinite_scroll_pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/chat_message/view/Chat_message_image_gallery.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_fragment.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';

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
                  return Center(
                    child: GrimityCircularProgressIndicator(),
                  );
                }

                return Stack(
                  children: [
                    InfiniteScrollPagination(
                      isEnabled: data.value!.nextCursor != null,
                      onLoadMore: provider.loadMore,
                      reverse: true,
                      child: ListView.separated(
                        separatorBuilder: (_, _) => SizedBox(height: 10),
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: data.value!.messages.length,
                        itemBuilder: (context, index) {
                          return ChatMessageFragment(
                            chatId: chatId,
                            model: data.value!.messages[index],
                          );
                        },
                      ),
                    ),

                    // 사용자가 선택한 이미지 목록 표시.
                    if (data.value!.inputImages.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ChatMessageImageGallery(chatId: chatId),
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
}
