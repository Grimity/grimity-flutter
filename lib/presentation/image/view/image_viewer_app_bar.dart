import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';

class ImageViewerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImageViewerAppBar({super.key, required this.currentIndex, required this.imageUrls, required this.enableSave});

  final int currentIndex;
  final List<String> imageUrls;
  final bool enableSave;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: GrimityGesture(
        onTap: () => context.pop(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Assets.icons.common.close.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
          ),
        ),
      ),
      titleSpacing: 0,
      title:
          imageUrls.length <= 1
              ? null
              : Row(
                children: [
                  Text('${currentIndex + 1} ', style: AppTypeface.body1.copyWith(color: AppColor.main)),
                  Text('/ ${imageUrls.length}', style: AppTypeface.body1.copyWith(color: AppColor.gray00)),
                ],
              ),
      actions: [
        if (enableSave)
          Consumer(
            builder: (context, ref, child) {
              final isSaving = ref.watch(imageSaveProvider).isLoading;

              return GrimityGesture(
                onTap:
                    isSaving
                        ? null
                        : () => ref.read(imageSaveProvider.notifier).saveByUrl(imageUrls[currentIndex]),
                child: Assets.icons.common.download.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.kToolbarHeight.height);
}
