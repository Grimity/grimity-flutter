import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';

class PhotoSelectAppBar extends ConsumerWidget with PhotoSelectMixin implements PreferredSizeWidget {
  const PhotoSelectAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return photosAsync(ref).maybeWhen(
      data: (state) {
        if (!state.hasAccess) {
          return _buildCloseAppBar(context);
        }

        final isActive = state.selected.isNotEmpty;
        return AppBar(
          toolbarHeight: AppTheme.kToolbarHeight.height,
          leading: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => context.pop(),
              child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
            ),
          ),
          title: Column(children: [Text('그림 선택', style: AppTypeface.subTitle3)]),
          titleSpacing: 0,
          actions: [
            TextButton(
              onPressed:
                  isActive
                      ? () {
                        photoNotifier(ref).completeImageSelect(context);
                      }
                      : null,
              child: Text(
                '다음',
                style: isActive ? AppTypeface.subTitle4 : AppTypeface.subTitle4.copyWith(color: AppColor.gray500),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.zero,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColor.gray300),
          ),
        );
      },
      orElse: () => _buildCloseAppBar(context),
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;

  _buildCloseAppBar(BuildContext context) => AppBar(
    toolbarHeight: AppTheme.kToolbarHeight.height,
    leading: Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context.pop(),
        child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
      ),
    ),
  );
}
