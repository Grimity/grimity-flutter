import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

class MainFloatingActionButton extends StatelessWidget {
  const MainFloatingActionButton({super.key, required this.currentIndex});

  final int currentIndex;

  // GdsBottomNavigation.main() 아이템 순서 기준
  static const _boardIndex = 3;
  static const _chatMessageIndex = 4;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;
    final assetImage = currentIndex == _boardIndex ? Assets.icons.icon.plusPost : Assets.icons.icon.plus;

    return GdsGesture(
      onTap: () => _onFabTap(context),
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

  void _onFabTap(BuildContext context) {
    switch (currentIndex) {
      case _boardIndex:
        PostUploadRoute().push(context);
      case _chatMessageIndex:
        NewChatRoute().push(context);
      default:
        FeedUploadRoute().push(context);
    }
  }
}
