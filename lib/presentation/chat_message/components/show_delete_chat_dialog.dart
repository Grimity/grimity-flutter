import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';

Future<T?> showDeleteChatDialog<T>({required BuildContext context, required String chatId}) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '채팅방을 나가시겠어요?',
    description: '지금까지 대화한 내용이 모두 사라지고\n복구가 불가능합니다.',
    primaryLabel: '채팅방 나가기',
    secondaryLabel: '아니요',
    onSecondaryTap: () => context.pop(),
    onPrimaryTap: () async {
      await getIt<ChatAPI>().deleteChat(chatId);

      // 채팅방 자체가 제거되었으므로 관련 모달 및 현재 페이지 닫기.
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    },
  );

  return alert.open<T>(context);
}
