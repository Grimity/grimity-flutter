import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';

class GrimityUserProfile extends StatelessWidget {
  const GrimityUserProfile._({
    super.key,
    this.imageUrl,
    this.title,
    this.subTitle,
    this.titleBuilder,
    this.subTitleBuilder,
  });

  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final Widget Function()? titleBuilder;
  final Widget Function()? subTitleBuilder;

  /// 기본형 String 기반
  factory GrimityUserProfile.fromString({
    String? imageUrl,
    required String title,
    String? subTitle,
    Key? key,
  }) => GrimityUserProfile._(key: key, imageUrl: imageUrl, title: title, subTitle: subTitle);

  /// Builder 기반
  factory GrimityUserProfile.fromBuilder({
    String? imageUrl,
    Widget Function()? titleBuilder,
    Widget Function()? subTitleBuilder,
    Key? key,
  }) =>
      GrimityUserProfile._(key: key, imageUrl: imageUrl, titleBuilder: titleBuilder, subTitleBuilder: subTitleBuilder);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        GrimityUserImage(imageUrl: imageUrl),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              if (titleBuilder != null) titleBuilder!() else if (title != null) Text(title!, style: AppTypeface.label1),
              if (subTitleBuilder != null)
                subTitleBuilder!()
              else if (subTitle != null && subTitle!.isNotEmpty)
                Text(
                  subTitle!,
                  style: AppTypeface.caption2.copyWith(color: AppColor.gray600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
