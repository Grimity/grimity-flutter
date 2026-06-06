import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatSearchBar extends ConsumerWidget {
  const ChatSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final isSelectMode = data.value?.isSelectMode ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: GdsSpacing.spacing8,
        horizontal: GdsSpacing.spacing20,
      ),
      child: GdsTextField.search(
        size: GdsTextFieldSize.small,
        placeholder: '작가 이름을 검색해보세요',
        enabled: !isSelectMode || !provider.isChatEmpty,
        onChanged: provider.setKeyword,
        onEditingComplete: provider.refresh,
      ),
    );
  }
}
