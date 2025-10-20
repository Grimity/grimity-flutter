import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';

class NewChatEmptyView extends StatelessWidget {
  const NewChatEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SvgPicture.asset(Assets.icons.chat.user.path),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text(
                "아직 팔로우하는 작가가 없어요",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.gray700,
                ),
              ),
              Text(
                "관심 있는 작가를 팔로우하고\n"
                "메세지를 주고 받아 보세요",
                style: TextStyle(color: AppColor.gray500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}