import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_bar_provider.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(mainBottomNavigationBarProvider);

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
                    ref.read(mainBottomNavigationBarProvider.notifier).setCurrentTab(e);
                  },
                  child: SvgPicture.asset(
                    e.icon.path,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      currentTab == e ? AppColor.gray700 : AppColor.gray500,
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
