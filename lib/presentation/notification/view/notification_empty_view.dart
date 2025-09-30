import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Assets.icons.common.alram.svg(width: 60, height: 60),
            Gap(16),
            Text('새로운 알림이 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
            Gap(6),
            Text(
              '내 글의 댓글와 좋아요, 다른 작가의 활동 등\n새로운 소식을 알려드려요',
              style: AppTypeface.label2.copyWith(color: AppColor.gray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
