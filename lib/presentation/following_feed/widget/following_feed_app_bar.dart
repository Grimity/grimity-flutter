import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/button/grimity_action_button.dart';

class FollowingFeedAppBar extends StatelessWidget {
  const FollowingFeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Text('팔로잉', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      actions: [GrimityActionButton.menu(context)],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }
}
