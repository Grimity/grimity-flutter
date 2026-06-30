import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerView extends ConsumerWidget {
  const ImageViewerView({
    super.key,
    required this.imageUrls,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.isZoomed,
    required this.onZoomChanged,
    required this.onClose,
  });

  final List<String> imageUrls;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final bool isZoomed;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(imageSaveProvider).isLoading;

    return SafeArea(
      child: Stack(
        children: [
          _ImageViewerPageView(
            imageUrls: imageUrls,
            pageController: pageController,
            onPageChanged: onPageChanged,
            isZoomed: isZoomed,
            onZoomChanged: onZoomChanged,
            onClose: onClose,
          ),

          if (imageUrls.length > 1) ...[
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _ImageViewerThumbnailView(
                  imageUrls: imageUrls,
                  currentIndex: currentIndex,
                  pageController: pageController,
                ),
              ),
            ),
          ],

          if (isLoading) ...[
            Center(child: GdsCircularLoading()),
          ],
        ],
      ),
    );
  }
}

class _ImageViewerPageView extends StatelessWidget {
  const _ImageViewerPageView({
    required this.imageUrls,
    required this.pageController,
    required this.onPageChanged,
    required this.isZoomed,
    required this.onZoomChanged,
    required this.onClose,
  });

  final List<String> imageUrls;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final bool isZoomed;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: imageUrls.length,
      physics: isZoomed ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return _ZoomableImage(
          imageUrl: imageUrls[index],
          onZoomChanged: onZoomChanged,
          onClose: onClose,
        );
      },
    );
  }
}

class _ZoomableImage extends HookWidget {
  const _ZoomableImage({
    required this.imageUrl,
    required this.onZoomChanged,
    required this.onClose,
  });

  final String imageUrl;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scaleStateController = useMemoized(() => PhotoViewScaleStateController());
    final isZoomed = useState(false);

    useEffect(() {
      final sub = scaleStateController.outputScaleStateStream.listen((state) {
        final zoomed = state != PhotoViewScaleState.initial;
        isZoomed.value = zoomed;
        onZoomChanged(zoomed);
      });
      return () {
        sub.cancel();
        scaleStateController.dispose();
      };
    }, []);

    return PhotoView(
      imageProvider: CachedNetworkImageProvider(imageUrl),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      scaleStateController: scaleStateController,
      onTapUp: isZoomed.value ? null : (_, _, _) => onClose(),
    );
  }
}

class _ImageViewerThumbnailView extends StatelessWidget {
  const _ImageViewerThumbnailView({
    required this.imageUrls,
    required this.currentIndex,
    required this.pageController,
  });

  final List<String> imageUrls;
  final int currentIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdsColors;

    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: GdsSpacing.spacing8),
      color: colors.bg.black.withOpacity(GdsOpacity.opacity80),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: GdsSpacing.spacing8,
          children: [
            ...imageUrls.mapIndexed((index, imageUrl) {
              final isSelected = index == currentIndex;

              return GdsGesture(
                onTap: () => pageController.jumpToPage(index),
                child: Opacity(
                  opacity: isSelected ? 1 : 0.5,
                  child: GdsThumbnail(
                    imageUrl: imageUrl,
                    width: GdsSpacing.spacing64,
                    height: GdsSpacing.spacing64,
                    borderRadius: BorderRadius.circular(GdsRadius.lg),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
