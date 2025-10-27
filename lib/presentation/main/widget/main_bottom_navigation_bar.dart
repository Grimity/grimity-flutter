import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_user_image.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomNavigationBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userImageUrl = ref.watch(userAuthProvider)?.image;

    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .9),
          border: Border(top: BorderSide(color: AppColor.gray300.withValues(alpha: .9))),
          boxShadow: [BoxShadow(offset: Offset(0, -2), color: Colors.black.withValues(alpha: .04), blurRadius: 6)],
        ),
        child: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              MainNavigationItem.values
                  .map((e) => _MainBottomNavItem(item: e, navigationShell: navigationShell, userImageUrl: userImageUrl))
                  .toList(),
        ),
      ),
    );
  }
}

class _MainBottomNavItem extends StatelessWidget {
  const _MainBottomNavItem({required this.item, required this.navigationShell, this.userImageUrl});

  final MainNavigationItem item;
  final StatefulNavigationShell navigationShell;
  final String? userImageUrl;

  bool get isActive => navigationShell.currentIndex == item.index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GrimityAnimationButton(
        onTap: () => goBranch(item.index, isActive),
        child: Center(child: Padding(padding: EdgeInsets.only(bottom: 12), child: _buildIcon())),
      ),
    );
  }

  Widget _buildIcon() {
    // my
    if (item == MainNavigationItem.my) {
      return Container(
        decoration:
            isActive
                ? BoxDecoration(border: Border.all(width: 2, color: AppColor.gray700), shape: BoxShape.circle)
                : null,
        child:
            (userImageUrl != null)
                ? GrimityUserImage(imageUrl: userImageUrl!, size: 22, decoration: BoxDecoration())
                : SvgPicture.asset(item.icon.path, width: 22, height: 22),
      );
    }

    // home, ranking, following, board
    return SvgPicture.asset(
      item.icon.path,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(isActive ? AppColor.gray700 : AppColor.gray500, BlendMode.srcIn),
    );
  }

  void goBranch(int index, bool initialLocation) {
    navigationShell.goBranch(index, initialLocation: initialLocation);
  }
}
