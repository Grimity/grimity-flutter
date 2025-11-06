import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/data/model/user/user_base_response.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/chat_message/components/show_delete_chat_dialog.dart';
import 'package:grimity/presentation/chat_message/provider/chat_message_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';

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
      title: data.isLoading ? SizedBox() : _BodyArea(
        chatId: chatId,
        model: data.value!.opponentUser
      ),
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

class _BodyArea extends StatelessWidget {
  const _BodyArea({
    required this.chatId,
    required this.model,
  });

  final String chatId;
  final UserBaseResponse model;

  void openBottomSheet(BuildContext context) {
    GrimityModalBottomSheet.show(context, buttons: [
      GrimityModalButtonModel(
        title: "신고하기",
        onTap: () {
          Navigator.pop(context);

          // 신고 페이지로 이동.
          ReportRoute(refType: ReportRefType.chat, refId: chatId).push(context);
        },
      ),
      GrimityModalButtonModel(
        title: "채팅방 나가기",
        onTap: () => showDeleteChatDialog(context: context, chatId: chatId),
      )
    ]);
  }

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
            style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4),
          ),
        ),

        // 더보기 버튼 표시.
        GrimityGesture(
          onTap: () => openBottomSheet(context),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Assets.icons.chatMessage.more.svg(),
          ),
        ),
      ],
    );
  }
}
