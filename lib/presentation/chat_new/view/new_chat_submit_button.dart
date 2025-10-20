import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';

class NewChatSubmitButton extends ConsumerWidget {
  const NewChatSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(newChatProviderProvider);
    final isEnabled = data.value?.selectedUserId != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: GrimityButton.large(
        text: '보내기',
        onTap: () => ref.read(newChatProviderProvider.notifier).submit(context),
        status: isEnabled ? ButtonStatus.on : ButtonStatus.off,
      ),
    );
  }
}
