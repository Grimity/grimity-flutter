import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/follow/enum/follow_enum_tab_type.dart';

class FollowTabWidget extends StatelessWidget {
  final FollowTabType type;

  const FollowTabWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6,
        children: [
          Text(type.title),
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(userAuthProvider);
              final count = type == FollowTabType.follower ? user?.followerCount : user?.followingCount;
              return Text(count.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray600));
            },
          ),
        ],
      ),
    );
  }
}
