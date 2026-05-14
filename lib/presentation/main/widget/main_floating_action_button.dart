import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/main/provider/main_bottom_navigation_item.dart';

class MainFloatingActionButton extends StatelessWidget {
  const MainFloatingActionButton({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;
    final currentItem = MainNavigationItem.values[currentIndex];
    final assetImage = currentItem == MainNavigationItem.board ? Assets.icons.icon.plusPost : Assets.icons.icon.plus;

    return GdsGesture(
      onTap: () => currentItem.onFabTap(context),
      child: Container(
        width: 54,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface.primaryNormal,
          boxShadow: GdsShadows.level2,
        ),
        child: assetImage.svg(
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(colors.icon.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
