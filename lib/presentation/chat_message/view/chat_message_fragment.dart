import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/ux/popover.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/chat_message/view/chat_message_popover_menu.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';

class ChatMessageFragment extends ConsumerStatefulWidget {
  const ChatMessageFragment({super.key, required this.chatId, required this.model});

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
          padding: EdgeInsets.only(left: GdsSpacing.spacing10),
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
    final providerFamily = chatMessageProviderProvider(chatId: widget.chatId);
    final state = ref.watch(providerFamily).value;
    final model = widget.model;
    final user = ref.watch(userAuthProvider);
    final isMe = user?.id == model.userId;
    final messageType = isMe ? GdsChatMessageType.me : GdsChatMessageType.other;

    void openImageViewer() {
      ImageViewerRoute(imageUrls: [model.image!], initialIndex: 0, enableSave: true).push(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(
              // 100px 더 작게 제약하되 최대 240px으로 수평 크기를 제한.
              maxWidth: constraints.maxWidth - 80,
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing6,
              children: [
                CompositedTransformTarget(
                  link: layerLink,
                  child: GdsChatBubble(
                    type: messageType,
                    content: model.content,
                    imageUrl: model.image,
                    isLiked: model.isLike,
                    onTap: !isMe
                        ? () {
                            // 좋아요, 답장과 같은 액션 버튼 표시.
                            if (!isMe) {
                              (_popover = createPopover()).show(context);
                            }
                          }
                        : null,
                    onImageTap: openImageViewer,
                    replyPreviewData: model.replyTo != null
                        ? GdsChatReplyPreviewData(
                            replyType: isMe ? GdsChatMessageType.other : GdsChatMessageType.me,
                            replyLabel: isMe ? '[${state?.opponentUser.name}]님에게 답장' : "나에게 답장",
                            content: model.replyTo?.content ?? '',
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
