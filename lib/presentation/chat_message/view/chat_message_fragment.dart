import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/ux/popover.dart';
import 'package:grimity/data/model/chat_message/chat_message_reply_response.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_image_view.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_popover_menu.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class ChatMessageFragment extends ConsumerStatefulWidget {
  const ChatMessageFragment({
    super.key,
    required this.chatId,
    required this.model,
  });

  final String chatId;
  final ChatMessage model;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatMessageFragmentState();
}

class _ChatMessageFragmentState extends ConsumerState<ChatMessageFragment> {
  final LayerLink layerLink = LayerLink();

  Popover? _popover;
  Popover createPopover() {
    return Popover(
      targetLink: layerLink,
      targetAnchor: Alignment.bottomRight,
      followerAnchor: Alignment.bottomLeft,
      builder: (popover) {
        return Padding(
          padding: EdgeInsets.only(left: 10),
          child: ChatMessagePopoverMenu(
            chatId: widget.chatId,
            message: widget.model,
            popover: popover,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _popover?.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final user = ref.watch(userAuthProvider);
    final isMe = user?.id == model.userId;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          child: CompositedTransformTarget(
            link: layerLink,
            child: GestureDetector(
              onTap: () {
                if (!isMe) {
                  // 좋아요, 답장과 같은 액션 버튼 표시.
                  (_popover = createPopover()).show(context);
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  // 100px 더 작게 제약하되 최대 240px으로 수평 크기를 제한.
                  maxWidth: min((constraints.maxWidth - 100), 240),
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    if (model.replyTo != null)
                      _ReplyView(isMe: isMe, model: model.replyTo!, chatId: widget.chatId),

                    if (model.image != null)
                      ChatMessageImageView(imageUrl: model.image!),

                    if (model.content != null)
                      _MessageBubble(isMe: isMe, text: model.content!),
                  ],
                ),
              ),
            ),
          )
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.isMe,
    required this.text,
  });

  final bool isMe;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isMe ? AppColor.main : AppColor.gray300,
        borderRadius: switch(isMe) {
          true => BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
          false => BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        },
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isMe ? AppColor.gray00 : AppColor.gray800,
        ),
      ),
    );
  }
}

class _ReplyView extends ConsumerWidget {
  const _ReplyView({
    required this.isMe,
    required this.model,
    required this.chatId,
  });

  final bool isMe;
  final ChatMessageReplyResponse model;
  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chatMessageProviderProvider(chatId: chatId));
    final user = data.value!.opponentUser;

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          isMe ? "${user.name}님에게 답장" : "나에게 답장",
          style: TextStyle(fontSize: 12, color: AppColor.gray500),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Assets.icons.chatMessage.deliver.svg(
              color: AppColor.gray500,
              width: 18,
              height: 18,
            ),
            Builder(
              builder: (context) {
                if (model.content == null) {
                  return ChatMessageImageView(
                    imageUrl: model.image!,
                    width: 60,
                    height: 60,
                  );
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.gray300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    model.content!,
                    style: TextStyle(
                      color: AppColor.gray800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
