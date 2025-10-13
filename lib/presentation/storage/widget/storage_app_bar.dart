import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab.dart';
import 'package:grimity/presentation/common/widget/system/tabs/grimity_tab_bar.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';

class StorageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StorageAppBar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('보관함', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
      centerTitle: false,
      bottom: GrimityTabBar.small(
        tabController: tabController,
        buildTabs:
            (currentIndex) =>
                StorageTabType.values
                    .map(
                      (e) => GrimityTab.small(
                        text: e.title,
                        tabStatus: currentIndex == e.index ? GrimityTabStatus.on : GrimityTabStatus.off,
                      ),
                    )
                    .toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height + GrimityTabBarSize.small.height);
}
