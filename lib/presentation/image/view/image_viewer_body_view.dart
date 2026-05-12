import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerBodyView extends StatelessWidget {
  const ImageViewerBodyView({
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: _ImageViewerPageView(
                  imageUrls: imageUrls,
                  pageController: pageController,
                  onPageChanged: onPageChanged,
                  isZoomed: isZoomed,
                  onZoomChanged: onZoomChanged,
                  onClose: onClose,
                ),
              ),
              if (imageUrls.length > 1)
                _ImageViewerThumbnailView(
                  imageUrls: imageUrls,
                  currentIndex: currentIndex,
                  pageController: pageController,
                ),
            ],
          ),

          /// 이미지 저장 진행 중 로딩 표시
          Consumer(
            builder: (context, ref, child) {
              final isSaving = ref.watch(imageSaveProvider).isLoading;

              if (isSaving) return Center(child: GdsCircularLoading());

              return SizedBox.shrink();
            },
          ),
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
      onTapUp: isZoomed.value ? null : (_, __, ___) => onClose(),
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

    return Padding(
      padding: const EdgeInsets.only(
        top: GdsSpacing.spacing16,
        bottom: GdsSpacing.spacing32,
        left: GdsSpacing.spacing16,
      ),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final isSelected = index == currentIndex;
            return GdsGesture(
              onTap: () => pageController.jumpToPage(index),
              child: Container(
                decoration: BoxDecoration(
                  border: isSelected ? Border.all(color: colors.icon.primaryNormal, width: 1) : null,
                ),
                child: GdsThumbnail(
                  imageUrl: imageUrls[index],
                  width: 48,
                  height: 48,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => Gap(GdsSpacing.spacing6),
        ),
      ),
    );
  }
}
