import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';
import 'package:grimity/presentation/image/view/image_viewer_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageViewerPage extends HookWidget {
  const ImageViewerPage({super.key, required this.imageUrls, required this.initialIndex, this.enableSave = false});

  final List<String> imageUrls;
  final int initialIndex;
  final bool enableSave;

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(initialIndex);
    final pageController = usePageController(initialPage: initialIndex);
    final isZoomed = useState(false);
    final colors = context.gdsColors;

    final foregroundColor = colors.bg.black.withOpacity(GdsOpacity.opacity40);
    final backgroundColor = colors.surface.base;
    final blendedColor = Color.alphaBlend(foregroundColor, backgroundColor);

    return GdsToastHost(
      child: ColoredBox(
        color: blendedColor,
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragEnd: (details) {
                if (!isZoomed.value && (details.primaryVelocity ?? 0) > 300) {
                  context.pop();
                }
              },
              child: ImageViewerView(
                imageUrls: imageUrls,
                currentIndex: currentIndex.value,
                pageController: pageController,
                onPageChanged: (index) {
                  currentIndex.value = index;
                  isZoomed.value = false;
                },
                isZoomed: isZoomed.value,
                onZoomChanged: (zoomed) => isZoomed.value = zoomed,
                onClose: () => context.pop(),
              ),
            ),
            SafeArea(
              child: Consumer(
                builder: (context, ref, _) {
                  return GdsTopNavigation.imageViewer(
                    onClose: context.pop,
                    onDownload: () {
                      final imageUrl = imageUrls[currentIndex.value];
                      ref.read(imageSaveProvider.notifier).saveByUrl(imageUrl);
                    },
                    showDownload: enableSave,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
