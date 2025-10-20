import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

class ChatFloatingActionButton extends StatelessWidget {
  const ChatFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 새 메세지 보내기 페이지로 이동.
        NewChatRoute().push(context);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primary4),
        child: Assets.icons.main.add.svg(width: 24, height: 24, fit: BoxFit.scaleDown),
      ),
    );
  }
}