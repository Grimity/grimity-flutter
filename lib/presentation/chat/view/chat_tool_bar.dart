import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat/components/show_delete_chats_dialog.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/common/widget/grimity_transition.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_check_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatToolBar extends ConsumerWidget {
  const ChatToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final hasSelected = data.value?.selectedChats.isNotEmpty ?? false;
    final isSelectMode = data.value?.isSelectMode ?? false;
    final isSelectedAll = data.value?.chats.length == data.value?.selectedChats.length;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 30,
      child: GrimityTransition(
        child: Builder(
          key: ValueKey(isSelectMode),
          builder: (context) {
            if (isSelectMode) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  GrimityCheckBox.withLabeled(
                    value: isSelectedAll,
                    label: "전체 선택",
                    onTap: () {},
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      GrimityButton.round(
                        text: "채팅 나가기",
                        status: hasSelected ? ButtonStatus.on : ButtonStatus.off,
                        onTap: () async {
                          assert(hasSelected);
                          await showDeleteChatsDialog(context: context, chatIds: data.value!.selectedChats);

                          // 일부 채팅이 제거되었으므로 목록 새로고침.
                          provider.refresh();
                        },
                      ),
                      GrimityButton.round(
                        text: "닫기",
                        style: ButtonStyleType.line,
                        prefixIcon: Assets.icons.common.close,
                        onTap: () => provider.setSelectMode(false),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GrimityButton.round(
                  text: "편집",
                  style: ButtonStyleType.line,
                  prefixIcon: Assets.icons.chat.edit,
                  onTap: () => provider.setSelectMode(true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
