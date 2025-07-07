import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomNavigationBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...MainNavigationItem.values.map((e) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16.5, 12, 16.5, 24),
                child: GrimityAnimationButton(
                  onTap: () {
                    navigationShell.goBranch(e.index, initialLocation: e.index == navigationShell.currentIndex);
                  },
                  child: SvgPicture.asset(
                    e.icon.path,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      navigationShell.currentIndex == e.index ? AppColor.gray700 : AppColor.gray500,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
