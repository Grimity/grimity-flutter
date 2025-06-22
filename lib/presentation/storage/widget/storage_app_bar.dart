import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/widget/storage_tab_chip.dart';

class StorageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StorageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('보관함', style: AppTypeface.subTitle3.copyWith(color: AppColor.primary4)),
      titleSpacing: 0,
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppTheme.kBottomBarHeight.height + 1),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(spacing: 6.w, children: StorageTabType.values.map((e) => StorageTabChip(type: e)).toList()),
              ),
              Divider(height: 1, color: AppColor.gray300),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height + AppTheme.kBottomBarHeight.height + 1);
}
