import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/gen/models/batch_delete_chats_request.dart';
import 'package:grimity/data/gen/rest_client.dart';

Future<T?> showDeleteChatsDialog<T>({required BuildContext context, required List<String> chatIds}) {
  final alert = GdsAlert(
    size: context.isMobile ? GdsAlertSize.md : GdsAlertSize.xl,
    title: '채팅방을 나가시겠어요?',
    description: '지금까지 대화한 내용이 모두 사라지고\n복구가 불가능합니다.',
    primaryLabel: '나가기',
    secondaryLabel: '아니요',
    onSecondaryTap: () => context.pop(),
    onPrimaryTap: () async {
      context.pop();
      await getIt<RestClient>().chats.chatDeleteManyChat(body: BatchDeleteChatsRequest(ids: chatIds));
    },
  );

  return alert.open<T>(context);
}
