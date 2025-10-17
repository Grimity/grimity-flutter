import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/widget/button/grimity_button.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';

/// GrimityFollowButton
/// 해당 User 정보가 없을 때 url을 통해 Follow 버튼 구성
class GrimityFollowButton extends ConsumerWidget {
  final String url;

  const GrimityFollowButton({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider(url));

    return profileAsync.maybeWhen(
      data: (user) {
        final isFollowing = user?.isFollowing ?? false;

        return GrimityButton.follow(
          isFollowing: isFollowing,
          onTap: () => ref.read(profileDataProvider(url).notifier).toggleFollow(),
        );
      },
      orElse: () => SizedBox(),
    );
  }
}
