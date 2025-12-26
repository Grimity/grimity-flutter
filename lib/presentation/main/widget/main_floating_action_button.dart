import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class MainFloatingActionButton extends StatelessWidget {
  const MainFloatingActionButton({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final assetImage =
        currentIndex == MainNavigationItem.board.index ? Assets.icons.icon.plusPost : Assets.icons.icon.plus;

    return GrimityGesture(
      onTap: () => MainNavigationItem.values[currentIndex].onFabTap(context),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primary4),
        child: assetImage.svg(
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
        ),
      ),
    );
  }
}
