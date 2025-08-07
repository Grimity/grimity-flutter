import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';

class GrimityFollowButton extends ConsumerWidget {
  final String url;

  const GrimityFollowButton({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(url));

    return profileAsync.maybeWhen(
      data: (user) {
        final isFollowing = user?.isFollowing ?? false;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ref.read(profileDataProvider(url).notifier).toggleFollow();
          },
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              border:
                  isFollowing ? Border.all(color: AppColor.gray300) : Border.all(color: AppColor.primary4, width: 1),
              borderRadius: BorderRadius.circular(50),
              color: isFollowing ? AppColor.gray00 : AppColor.primary4,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Center(
                child: Text(
                  isFollowing ? '언팔로우' : '팔로우',
                  style: AppTypeface.caption3.copyWith(color: isFollowing ? AppColor.gray700 : AppColor.gray00),
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => SizedBox(),
    );
  }
}
