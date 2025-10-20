import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class ChatMessageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatMessageAppBar({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chatMessageProviderProvider(chatId: chatId));

    return AppBar(
      title: data.isLoading ? SizedBox() : _Profile(model: data.value!.opponentUser),
      titleSpacing: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}

class _Profile extends StatelessWidget {
  const _Profile({
    required this.model,
  });

  final UserBaseResponse model;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        // 사용자 프로필 이미지 표시.
        GrimityUserImage(imageUrl: model.image, size: 30),

        // 사용자 이름 표시.
        Expanded(
          child: Text(
            model.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
