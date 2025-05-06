import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/app/config/app_color.dart';
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
              return _MainNavigationIconButton(
                item: e,
                isSelected: currentTab == e,
                onTap: () {
                  ref.read(mainBottomNavigationBarProvider.notifier).setCurrentTab(e);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MainNavigationIconButton extends HookWidget {
  final MainNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _MainNavigationIconButton({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 160));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        animationController.forward(from: 0);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.5, 12, 16.5, 24),
        child: SvgPicture.asset(
              item.icon.path,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(isSelected ? AppColor.gray700 : AppColor.gray500, BlendMode.srcIn),
            )
            .animate(controller: animationController)
            .scale(duration: 80.ms, curve: Curves.easeOut, begin: const Offset(1.0, 1.0), end: const Offset(1.12, 1.12))
            .then()
            .scale(duration: 80.ms, curve: Curves.easeIn, begin: const Offset(1.12, 1.12), end: const Offset(1.0, 1.0)),
      ),
    );
  }
}
