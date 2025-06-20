import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_bottom_sheet.dart';

class ProfileEditBackground extends ConsumerWidget {
  const ProfileEditBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundImage = ref.watch(profileEditProvider).backgroundImage;

    return Stack(children: [GrimityProfileBackgroundImage(url: backgroundImage), _ProfileEditBackgroundEditButton()]);
  }
}

class _ProfileEditBackgroundEditButton extends ConsumerWidget {
  const _ProfileEditBackgroundEditButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      right: 16,
      bottom: 16,
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => showBackgroundImageBottomSheet(context, ref),
          child: Container(
            width: 69.w,
            height: 34.w,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text("커버 변경", style: AppTypeface.caption2)),
          ),
        ),
      ),
    );
  }
}
