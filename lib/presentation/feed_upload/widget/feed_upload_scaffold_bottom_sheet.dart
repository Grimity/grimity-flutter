import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';

class FeedUploadScaffoldBottomSheet extends StatelessWidget {
  const FeedUploadScaffoldBottomSheet({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.gray00,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, color: AppColor.gray300),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: height,
              child: Row(
                children: [
                  GrimityAnimationButton(
                    onTap: () {
                      // 키보드가 올라와 있는 경우
                      // 포커스 해제하여 키보드 내림
                      if (MediaQuery.of(context).viewInsets.bottom > 0) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Assets.icons.feedUpload.keyboard.svg(width: 24, height: 24),
                  ),
                  Gap(16),
                  GrimityAnimationButton(
                    onTap: () => PhotoSelectRoute(type: UploadImageType.feed).push(context),
                    child: Assets.icons.feedUpload.camera.svg(width: 24, height: 24),
                  ),
                  Spacer(),
                  Consumer(
                    builder: (context, ref, child) {
                      final length = ref.watch(feedUploadProvider).content.length;

                      return Text('$length', style: AppTypeface.caption1.copyWith(color: AppColor.gray700));
                    },
                  ),
                  Text('/300', style: AppTypeface.caption1.copyWith(color: AppColor.gray500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
