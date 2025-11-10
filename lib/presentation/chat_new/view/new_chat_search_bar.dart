import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:grimity/presentation/common/widget/text_field/grimity_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewChatSearchBar extends StatelessWidget {
  const NewChatSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(16), color: AppColor.gray100, child: _SearchTextField());
  }
}

class _SearchTextField extends ConsumerWidget {
  const _SearchTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GrimityTextField.small(
      hintText: '작가 이름을 검색해 보세요',
      maxLines: 1,
      showSearchIcon: true,
      onSearch: ref.read(newChatProviderProvider.notifier).refresh,
      onChanged: ref.read(newChatProviderProvider.notifier).setKeyword,
      onSubmitted: (_) => ref.read(newChatProviderProvider.notifier).refresh(),
    );
  }
}
