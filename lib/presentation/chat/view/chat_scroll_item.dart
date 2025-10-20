import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/data/model/chat/chat_response.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class ChatScrollItem extends StatelessWidget {
  const ChatScrollItem({
    super.key,
    required this.model,
  });

  final ChatResponse model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 메세지 뷰어 페이지로 이동.
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.gray600,
                      ),
                    ),
                    CircleAvatar(backgroundColor: AppColor.gray400, radius: 1),
                    Text(
                      model.lastMessage.createdAt.toRelativeTime(), 
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
                  model.lastMessage.content ?? "사진을 보냈습니다.", 
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
