import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/chat/components/show_delete_chats_dialog.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatToolBar extends ConsumerWidget {
  const ChatToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final hasSelected = data.value?.selectedChats.isNotEmpty ?? false;
    final isSelectedAll = data.value?.chats.length == data.value?.selectedChats.length;

    return Container(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing16,
        left: GdsSpacing.spacing20,
        right: GdsSpacing.spacing20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GrimityCheckBox.withLabeled(
            isChecked: isSelectedAll,
            label: '전체 선택',
            onTap: () => provider.selectChatAll(!isSelectedAll),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing8,
            children: [
              GdsTextButton(
                variant: GdsTextButtonVariant.assistive,
                text: '채팅방 나가기',
                onPressed: () async {
                  if (!hasSelected) {
                    ToastService.showFailure('원하는 채팅방을 선택하세요.');
                    return;
                  }

                  await showDeleteChatsDialog(context: context, chatIds: data.value!.selectedChats);

                  // 일부 채팅이 제거되었으므로 목록 새로고침.
                  provider.refresh();
                },
              ),
              GdsDivider.primary(
                extent: GdsSpacing.spacing16,
                size: GdsDividerSize.vertical,
              ),
              GdsTextButton(
                variant: GdsTextButtonVariant.assistive,
                text: '아니요',
                onPressed: () => provider.setSelectMode(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
