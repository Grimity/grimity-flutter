import 'package:flutter/material.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/domain/dto/chat_request_params.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

Future<void> showDeleteChatsDialog({required BuildContext context, required List<String> chatIds}) {
  return showDialog(
    context: context,
    builder: (context) {
      return GrimityDialog(
        title: "채팅방을 나갈까요?",
        content: "지금까지 대화 내용이 모두 사라져요",
        cancelText: "취소",
        confirmText: "나가기",
        onConfirm: () async {
          await getIt<ChatAPI>().batchDeleteChat(BatchDeleteChatRequest(ids: chatIds));

          // 해당 모달 닫기.
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      );
    },
  );
}
