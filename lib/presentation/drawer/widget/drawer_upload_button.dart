import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class DrawerUploadButton extends StatelessWidget {
  const DrawerUploadButton({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Scaffold.of(context).closeEndDrawer();
        FeedUploadRoute(from: MainNavigationItem.values[currentIndex].routeName).push(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 42.h,
        decoration: BoxDecoration(color: AppColor.primary4, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text("그림 업로드", style: AppTypeface.label2.copyWith(color: AppColor.gray00))),
      ),
    );
  }
}
