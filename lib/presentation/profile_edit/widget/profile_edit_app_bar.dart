import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
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
        child: GrimityGesture(
          onTap: () {
            if (state.isSaved) {
              context.pop();
            } else {
              showCancelEditDialog(context);
            }
          },
          child: Assets.icons.icon.close.svg(width: 24, height: 24),
        ),
      ),
      title: Text('프로필 편집', style: AppTypeface.subTitle3),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
