import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimityActionButton extends StatelessWidget {
  const GrimityActionButton._({required this.icon, required this.onTap, this.size = 24});

  final SvgGenImage icon;
  final VoidCallback onTap;
  final double size;

  /// Search Action Button
  factory GrimityActionButton.search(BuildContext context) {
    return GrimityActionButton._(onTap: () => SearchRoute().push(context), icon: Assets.icons.home.search, size: 24);
  }

  /// TODO Storage, setting, Notifier, Share etc...

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: icon.svg(width: size.w, height: size.w));
  }
}
