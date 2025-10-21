import 'package:flutter/material.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/presentation/common/widget/alert/grimity_dialog.dart';

void showDeleteChatDialog({
  required BuildContext context,
  required String chatId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return GrimityDialog(
        title: "채팅방을 나갈까요?",
        content: "지금까지 대화 내용이 모두 사라져요",
        cancelText: "취소",
        confirmText: "나가기",
        onConfirm: () async {
          await getIt<ChatAPI>().deleteChat(chatId);

          // 채팅방 자체가 제거되었으므로 관련 모달 및 현재 페이지 닫기.
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
      );
    },
  );
}
