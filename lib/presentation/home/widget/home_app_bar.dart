import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/button/grimity_action_button.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: false,
      title: Assets.icons.icon.logo.svg(width: 90, height: 27),
      actions: [
        GrimityActionButton.search(context),
        Gap(20),
        Consumer(
          builder: (context, ref, child) {
            final hasNotification = ref.watch(userAuthProvider)?.hasNotification ?? false;

            return GrimityActionButton.notification(context, hasNotification: hasNotification);
          },
        ),
        Gap(20),
        GrimityActionButton.user(context),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.gray300),
      ),
    );
  }
}
