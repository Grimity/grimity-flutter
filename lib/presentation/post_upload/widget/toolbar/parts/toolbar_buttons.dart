import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_animation_button.dart';

class IconSquareButton extends StatelessWidget {
  const IconSquareButton({
    super.key,
    required this.child,
    this.active = false,
    this.activeColor = AppColor.gray700,
    this.onTap,
  });

  final Widget child;
  final bool active;
  final Color? activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: active ? activeColor : AppColor.gray00,
      ),
      child: onTap != null ? GrimityAnimationButton(onTap: onTap!, child: child) : child,
    );
  }
}
