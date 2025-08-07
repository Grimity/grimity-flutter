import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowingFeedEmptyView extends ConsumerWidget {
  const FollowingFeedEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userAuthProvider);

    return Column(children: [user?.followingCount == 0 ? _UserEmptyView() : _FeedEmptyView()]);
  }
}

class _FeedEmptyView extends StatelessWidget {
  const _FeedEmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          SvgPicture.asset(Assets.icons.common.user.path, width: 60),
          Gap(16),
          Text('아직 팔로우하는 작가가 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
          Gap(16),
          Text('관심 있는 작가를 팔로우하고', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
          Text('새로운 작품 소식을 받아보세요.', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
        ],
      ),
    );
  }
}

class _UserEmptyView extends StatelessWidget {
  const _UserEmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Text('아직 올라온 그림이 없어요 !', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
          Gap(16),
          Text('관심 있는 작가를 팔로우하고', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
          Text('새로운 작품 소식을 받아보세요.', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
        ],
      ),
    );
  }
}
