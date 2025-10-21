import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/data/model/chat/chat_response.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatScrollItem extends ConsumerWidget {
  const ChatScrollItem({
    super.key,
    required this.model,
  });

  final ChatResponse model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final idSelected = provider.hasSelected(model);
    final isSelectMode = data.value?.isSelectMode ?? false;

    return GrimityCheckBox.withFoldable(
      value: idSelected,
      isVisible: isSelectMode,
      onSelect: () => provider.selectChat(model, !idSelected),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 해당 채팅방 페이지로 이동.
          ChatMessageRoute(model.id).push(context);
        },
        child: Row(
          spacing: 12,
          children: [
            GrimityUserImage(imageUrl: model.opponentUser.image),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      // 사용자 이름 표시.
                      Text(
                        model.opponentUser.name, 
                        style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                      ),
                      CircleAvatar(backgroundColor: AppColor.gray400, radius: 1),
                      Text(
                        model.lastMessage?.createdAt.toRelativeTime()
                                  ?? model.enteredAt.toRelativeTime(), 
                        style: AppTypeface.caption1.copyWith(color: AppColor.gray600),
                      ),
                    ],
                  ),
                  // 최근 메세지 내용 표시.
                  Text(
                    model.lastMessage == null
                      ? "최근 메세지가 없습니다."
                      : model.lastMessage?.content ?? "사진을 보냈습니다.", 
                    style: AppTypeface.label3.copyWith(color: AppColor.gray800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            if (model.unreadCount > 0)
              _UnreadIndicator(unreadCount: model.unreadCount)
          ],
        ),
      ),
    );
  }
}

class _UnreadIndicator extends StatelessWidget {
  const _UnreadIndicator({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1e10),
        color: AppColor.accentRed,
      ),
      child: Text(
        unreadCount > 99 ? "99+" : unreadCount.toString(),
        style: AppTypeface.caption1.copyWith(color: AppColor.gray00),
      ),
    );
  }
}
