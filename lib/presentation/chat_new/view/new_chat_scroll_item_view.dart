import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/data/model/user/follow_user_response.dart';
import 'package:grimity/presentation/chat_new/provider/new_chat_provider.dart';
import 'package:grimity/presentation/common/widget/system/check/grimity_radio_button.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';

// 사용자가 팔로우하고 있는 사용자 정보를 표시합니다.
class NewChatScrollItemView extends ConsumerWidget {
  const NewChatScrollItemView({
    super.key,
    required this.model,
  });

  final FollowUserResponse model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(newChatProviderProvider.notifier);
    final data = ref.watch(newChatProviderProvider);
    assert(data.value != null);

    final isSelected = data.value!.selectedUserId == model.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 메세지를 보낼 대상으로 선택하기.
        provider.select(model);
      },
      child: Row(
        spacing: 16,
        children: [
          GrimityUserImage(imageUrl: model.image),

          // 간략한 사용자 정보 표시.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 사용자 이름 표시.
                Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.gray800,
                  ),
                ),
                // 사용자 아이디 표시.
                Text(
                  "@${model.url}",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.gray600,
                  ),
                ),
              ],
            ),
          ),
          GrimityRadioButton(
            value: isSelected,
            onTap: () => provider.select(model),
          ),
        ],
      ),
    );
  }
}