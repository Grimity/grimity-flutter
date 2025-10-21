import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/data/model/chat/chat_response.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // 해당 채팅방 페이지로 이동.
        await ChatMessageRoute(model.id).push(context);

        // 채팅방 페이지에서 나가면 기존 채팅 기록 새로고침.
        ref.read(chatProviderProvider.notifier).refresh();
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.gray600,
                      ),
                    ),
                    CircleAvatar(backgroundColor: AppColor.gray400, radius: 1),
                    Text(
                      model.lastMessage?.createdAt.toRelativeTime()
                                ?? model.enteredAt.toRelativeTime(), 
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColor.gray600,
                      ),
                    ),
                  ],
                ),
                // 최근 메세지 내용 표시.
                Text(
                  model.lastMessage == null
                    ? "최근 메세지가 없습니다."
                    : model.lastMessage?.content ?? "사진을 보냈습니다.", 
                  style: TextStyle(color: AppColor.gray800),
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
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.gray00,
        ),
      ),
    );
  }
}
