import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_user_image.dart';

class DrawerProfile extends ConsumerWidget {
  const DrawerProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrimityUserImage(imageUrl: user?.image),
        Gap(8),
        Text(user?.name ?? "", style: AppTypeface.subTitle3),
        Gap(2),
        Row(
          children: [
            Text("팔로워", style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
            Gap(4),
            Text("${user?.followingCount}", style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
            Gap(8),
            Text("팔로워", style: AppTypeface.label3.copyWith(color: AppColor.gray600)),
            Gap(4),
            Text("${user?.followerCount}", style: AppTypeface.label2.copyWith(color: AppColor.gray700)),
          ],
        ),
      ],
    );
  }
}
