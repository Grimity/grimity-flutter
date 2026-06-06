import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/presentation/chat/provider/chat_provider.dart';

class ChatAppBar extends ConsumerWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(chatProviderProvider.notifier);
    final data = ref.watch(chatProviderProvider);
    final isSelectMode = data.value?.isSelectMode ?? false;
    final colors = context.gdsColors;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: GdsSpacing.spacing8,
        horizontal: GdsSpacing.spacing20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'DM',
            style:
                context.isMobile
                    ? GdsTypography.title2.copyWith(color: colors.text.grayBold)
                    : GdsTypography.title1.copyWith(color: colors.text.grayBold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: GdsSpacing.spacing8,
            children: [
              GdsOutlinedButton(
                text: '새 메세지',
                size: GdsOutlinedButtonSize.small,
                enabled: !isSelectMode,
                onPressed: () => NewChatRoute().push(context),
              ),
              GdsOutlinedButton(
                text: '편집',
                size: GdsOutlinedButtonSize.small,
                enabled: !isSelectMode,
                onPressed: () => provider.setSelectMode(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
