import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';

class ImageViewerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImageViewerAppBar({super.key, required this.currentIndex, required this.imageUrls, required this.enableSave});

  final int currentIndex;
  final List<String> imageUrls;
  final bool enableSave;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return AppBar(
      backgroundColor: colors.bg.black,
      leading: GdsGesture(
        onTap: () => context.pop(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: GdsSpacing.spacing12, horizontal: GdsSpacing.spacing16),
          child: GdsIcon.xMark.build(color: GdsColors.white, width: 24, height: 24),
        ),
      ),
      titleSpacing: 0,
      title:
          imageUrls.length <= 1
              ? null
              : Row(
                children: [
                  Text('${currentIndex + 1} ', style: GdsTypography.body1SB.copyWith(color: colors.text.primaryNormal)),
                  Text('/ ${imageUrls.length}', style: GdsTypography.body1R.copyWith(color: GdsColors.white)),
                ],
              ),
      actions: [
        if (enableSave)
          Consumer(
            builder: (context, ref, child) {
              final isSaving = ref.watch(imageSaveProvider).isLoading;

              return GdsGesture(
                onTap: isSaving ? null : () => ref.read(imageSaveProvider.notifier).saveByUrl(imageUrls[currentIndex]),
                child: GdsIcon.download.build(color: GdsColors.white, width: 24, height: 24),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
