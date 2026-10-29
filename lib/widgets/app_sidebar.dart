import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/app/app_user.dart';
import 'package:grimity/presentation/profile/pages/profile_page.dart';

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
      profile: profile.image?.toImage(),
      followerCount: profile.followerCount.toInt(),
      followingCount: profile.followingCount.toInt(),
      onProfile: () => pushProfilePage(context),
      onNickname: () => pushProfilePage(context),
      onHandle: () => pushProfilePage(context),
      onFollower: () {}, // TODO
      onFollowing: () {}, // TODO
      onSignOut: AppUser.signOut,
      onTermsOfService: () {}, // TODO
      onPrivacyPolicy: () {}, // TODO
      onBusinessInfo: () {}, // TODO
      tabs: [], // TODO
    );
  }

  /// 본인 프로필 페이지로 이동.
  static void pushProfilePage(BuildContext context) {
    context.push(ProfilePage(url: profile.url));
  }
}
