import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewChatSearchBar extends ConsumerWidget {
  const NewChatSearchBar({
    super.key,
    required this.enabled,
    required this.isModal,
  });

  final bool enabled;
  final bool isModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: GdsSpacing.spacing8,
        left: isModal ? GdsSpacing.spacing20 : GdsSpacing.spacing16,
        right: isModal ? GdsSpacing.spacing20 : GdsSpacing.spacing16,
      ),
      child: GdsTextField.search(
        size: GdsTextFieldSize.medium,
        enabled: enabled,
        placeholder: '누구에게 메세지를 보낼까요?',
        onChanged: ref.read(newChatProviderProvider.notifier).setKeyword,
        onEditingComplete: ref.read(newChatProviderProvider.notifier).refresh,
      ),
    );
  }
}
