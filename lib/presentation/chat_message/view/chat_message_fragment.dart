import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_image_view.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class ChatMessageFragment extends ConsumerWidget {
  const ChatMessageFragment({
    super.key,
    required this.model,
  });

  final ChatMessage model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);
    final isMe = user?.id == model.userId;

    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 240),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (model.image != null)
              ChatMessageImageView(imageUrl: model.image!),

            if (model.content != null)
              _MessageBubble(isMe: isMe, text: model.content!),
          ],
        ),
      ),
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
