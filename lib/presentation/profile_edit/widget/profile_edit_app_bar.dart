import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_cancel_dialog.dart';

class ProfileEditAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ProfileEditAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);

    return AppBar(
      toolbarHeight: AppTheme.kToolbarHeight.height,
      leading: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (state.isSaved) {
              context.pop();
            } else {
              showCancelEditDialog(context);
            }
          },
          child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
        ),
      ),
      title: Text('프로필 편집', style: AppTypeface.subTitle3),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
