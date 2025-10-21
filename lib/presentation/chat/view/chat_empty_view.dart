import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';

class ChatEmptyView extends StatelessWidget {
  const ChatEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SvgPicture.asset(Assets.icons.chat.chat.path),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text(
                "주고 받은 메세지가 없어요",
                style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700),
              ),
              Text(
                "팔로우 한 작가에게 메세지를 보내보세요",
                style: AppTypeface.label2.copyWith(color: AppColor.gray500),
              ),
            ],
          ),
          GrimityButton.small(
            text: "새 메세지 보내기",
            onTap: () => NewChatRoute().push(context),
          ),
        ],
      ),
    );
  }
}