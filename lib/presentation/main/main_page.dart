import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/drawer/main_app_drawer.dart';
import 'package:grimity/presentation/home/home_page.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_bar_provider.dart'
    show mainBottomNavigationBarProvider;
import 'package:grimity/presentation/home/widget/home_app_bar.dart';
import 'package:grimity/presentation/main/widget/main_bottom_navigation_bar.dart';
import 'package:grimity/presentation/profile/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final List<PreferredSizeWidget?> appBars = [const HomeAppBar(), null, null, null, null];
final List<Widget> pages = [const HomePage(), Placeholder(), ProfilePage(), Placeholder(), Placeholder()];

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTabController = usePageController();

    final currentTab = ref.watch(mainBottomNavigationBarProvider).index;
    ref.listen(mainBottomNavigationBarProvider, (previous, next) {
      mainTabController.jumpToPage(next.index);
    });

    return Scaffold(
      appBar: appBars[currentTab],
      endDrawer: MainAppDrawer(),
      body: PageView(
        controller: mainTabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...pages.mapIndexed((index, e) => e.animate(target: currentTab == index ? 1 : 0).fade(duration: 200.ms)),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
