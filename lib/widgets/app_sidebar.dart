import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';

/// 프로필, 팔로우 정보, 탭 목록과 서비스 정보를 표시하는 사이드바 위젯.
class AppSidebar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsSidebar(
      size: context.whenDevice(
        mobile: .md,
        tablet: .lg,
      ),
      nickname: profile.name,
      handle: profile.url,
      profile: profile.image?.responsiveImage,
      followerCount: 0, // TODO
      followingCount: 0, // TODO
      onProfile: () {}, // TODO
      onNickname: () {}, // TODO
      onHandle: () {}, // TODO
      onFollower: () {}, // TODO
      onFollowing: () {}, // TODO
      onSignOut: () {}, // TODO
      onTermsOfService: () {}, // TODO
      onPrivacyPolicy: () {}, // TODO
      onBusinessInfo: () {}, // TODO
      tabs: [], // TODO
    );
  }
}
