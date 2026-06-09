import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMessageField extends HookConsumerWidget {
  const ChatMessageField({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerFamily = chatMessageProviderProvider(chatId: chatId);
    final provider = ref.read(providerFamily.notifier);
    final data = ref.watch(providerFamily);
    final state = data.value;
    final replyUser = state?.inputReply;
    final isReplyMode = replyUser != null;
    final isChatEnabled = state != null ? !(state.opponentUser.isBlocked || state.opponentUser.isBlocking) : true;
    final editingController = useTextEditingController();

    // View Model 측에서 텍스트 필드 내용을 수정할 수 있도록 관련 컨트롤러를 전달.
    provider.inputMessageController = editingController;

    if (isReplyMode) {
      return GdsDmInput.answer(
        replyUser: '${state?.opponentUser.name}님에게 답장',
        previewText: replyUser.content,
        enabled: isChatEnabled,
        controller: editingController,
        onCameraPressed: () => onCameraPressed(context, provider),
        onButtonPressed: provider.submit,
        onEditingComplete: provider.submit,
        onChanged: provider.setInputMessage,
      );
    }

    return GdsDmInput(
      enabled: isChatEnabled,
      controller: editingController,
      onCameraPressed: () => onCameraPressed(context, provider),
      onButtonPressed: provider.submit,
      onEditingComplete: provider.submit,
      onChanged: provider.setInputMessage,
    );
  }

  void onCameraPressed(BuildContext context, ChatMessageProvider provider) async {
    final List<ImageSourceItem>? pickedImages = await PhotoSelectRoute(
      type: UploadImageType.chat,
    ).push(context);

    // 사용자가 메세지에 함께 보낼 이미지를 선택한 경우.
    if (pickedImages != null && pickedImages.isNotEmpty) {
      provider.addInputImages(pickedImages);
    }
  }
}
