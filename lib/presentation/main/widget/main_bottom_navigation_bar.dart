import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomNavigationBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
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
                  .map((e) => _MainBottomNavItem(item: e, navigationShell: navigationShell))
                  .toList(),
        ),
      ),
    );
  }
}

class _MainBottomNavItem extends ConsumerWidget {
  const _MainBottomNavItem({required this.item, required this.navigationShell});

  final MainNavigationItem item;
  final StatefulNavigationShell navigationShell;

  bool get isActive => navigationShell.currentIndex == item.index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GrimityAnimationButton(
        onTap: () => goBranch(item.index, isActive),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: item.build(
              context,
              ref,
              SvgPicture.asset(
                item.icon.path,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(isActive ? AppColor.gray700 : AppColor.gray500, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goBranch(int index, bool initialLocation) {
    navigationShell.goBranch(index, initialLocation: initialLocation);
  }
}
