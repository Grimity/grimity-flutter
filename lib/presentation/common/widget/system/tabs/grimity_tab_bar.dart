import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';

enum GrimityTabBarSize {
  large,
  medium,
  small;

  double get height {
    switch (this) {
      case large:
        return 50.0;
      case GrimityTabBarSize.medium:
        return 46.0;
      case GrimityTabBarSize.small:
        return 52.0;
    }
  }
}

class GrimityTabBar extends StatelessWidget implements PreferredSizeWidget {
  const GrimityTabBar._({
    super.key,
    required this.tabController,
    required this.buildTabs,
    required this.tabBarSize,
    this.indicator,
    this.indicatorColor,
    this.indicatorSize,
    this.dividerColor,
    this.padding,
    this.labelPadding,
    this.tabAlignment,
    this.isScrollable = false,
    this.physics,
    this.overlayColor,
  });

  final GrimityTabBarSize tabBarSize;
  final TabController tabController;
  final List<Widget> Function(int currentIndex) buildTabs;

  // 옵션 스타일
  final Decoration? indicator;
  final Color? indicatorColor;
  final TabBarIndicatorSize? indicatorSize;
  final Color? dividerColor;
  final EdgeInsets? padding;
  final EdgeInsets? labelPadding;
  final TabAlignment? tabAlignment;
  final bool isScrollable;
  final ScrollPhysics? physics;
  final WidgetStateProperty<Color?>? overlayColor;

  /// large TabBar
  factory GrimityTabBar.large({
    Key? key,
    required TabController tabController,
    required List<Widget> Function(int currentIndex) buildTabs,
  }) => GrimityTabBar._(
    key: key,
    tabController: tabController,
    buildTabs: buildTabs,
    tabBarSize: GrimityTabBarSize.large,
    indicatorColor: AppColor.gray700,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: AppColor.gray300,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
  );

  /// medium TabBar
  factory GrimityTabBar.medium({
    Key? key,
    required TabController tabController,
    required List<Widget> Function(int currentIndex) buildTabs,
  }) => GrimityTabBar._(
    key: key,
    tabController: tabController,
    buildTabs: buildTabs,
    tabBarSize: GrimityTabBarSize.medium,
    indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: AppColor.gray700)),
    indicatorColor: AppColor.gray800,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: AppColor.gray300,
    padding: EdgeInsets.zero,
    tabAlignment: TabAlignment.start,
    isScrollable: true,
    physics: const NeverScrollableScrollPhysics(),
    overlayColor: WidgetStateProperty.all(Colors.transparent),
  );

  /// small TabBar
  factory GrimityTabBar.small({
    Key? key,
    required TabController tabController,
    required List<Widget> Function(int currentIndex) buildTabs,
  }) => GrimityTabBar._(
    key: key,
    tabController: tabController,
    buildTabs: buildTabs,
    tabBarSize: GrimityTabBarSize.small,
    padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
    labelPadding: const EdgeInsets.only(right: 6),
    dividerColor: AppColor.gray300,
    indicator: const BoxDecoration(),
    tabAlignment: TabAlignment.start,
    isScrollable: true,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final currentIndex = tabController.index;

        return Container(
          color: AppColor.gray00,
          child: TabBar(
            controller: tabController,
            indicator: indicator,
            indicatorColor: indicatorColor,
            indicatorSize: indicatorSize,
            dividerColor: dividerColor,
            padding: padding,
            labelPadding: labelPadding,
            tabAlignment: tabAlignment,
            isScrollable: isScrollable,
            physics: physics,
            overlayColor: overlayColor,
            tabs: buildTabs(currentIndex),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tabBarSize.height);
}
