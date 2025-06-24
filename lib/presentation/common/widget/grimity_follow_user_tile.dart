import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

// 팔로워, 팔로우 유저 표시 위젯
class FollowUserTile extends StatelessWidget {
  final User user;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const FollowUserTile._({super.key, required this.user, this.buttonText, this.onButtonTap});

  // 버튼 없는 UI
  factory FollowUserTile.plain({Key? key, required User user}) {
    return FollowUserTile._(key: key, user: user);
  }

  // 버튼 있는 UI
  factory FollowUserTile.withButton({
    Key? key,
    required User user,
    required String buttonText,
    required VoidCallback onButtonTap,
  }) {
    return FollowUserTile._(key: key, user: user, buttonText: buttonText, onButtonTap: onButtonTap);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56.h),
      child: Row(
        children: [
          GrimityUserImage(imageUrl: user.image),
          Gap(12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTypeface.label1),
                if ((user.description ?? '').isNotEmpty) ...[
                  Gap(2),
                  Text(
                    user.description!,
                    style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (buttonText != null && onButtonTap != null)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onButtonTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColor.gray00,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColor.gray300, width: 1),
                ),
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                child: Text(buttonText!, style: AppTypeface.caption3.copyWith(color: AppColor.gray700)),
              ),
            ),
        ],
      ),
    );
  }
}
