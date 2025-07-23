import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class FeedUploadAddImageButton extends StatelessWidget {
  const FeedUploadAddImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PhotoSelectRoute().push(context),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(color: AppColor.gray200, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.feedUpload.image.svg(width: 22, height: 27.5),
            Gap(16.5),
            Text('JPG / PNG', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
            Text('1장 당 10MB 이내', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
            Text('최대 10장까지 업로드', style: AppTypeface.caption2.copyWith(color: AppColor.gray500)),
          ],
        ),
      ),
    );
  }
}
