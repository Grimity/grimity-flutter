import 'package:cached_network_image/cached_network_image.dart';
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

class _ImageViewerThumbnailView extends HookWidget {
  const _ImageViewerThumbnailView({
    required this.imageUrls,
    required this.currentIndex,
    required this.pageController,
  });

  final List<String> imageUrls;
  final int currentIndex;
  final PageController pageController;

  static const duration = Duration(milliseconds: 250);
  static const curve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final pageIndex = useState(currentIndex);
    final colors = context.gdsColors;

    useEffect(() {
      assert(pageController.hasClients);

      final position = pageController.position;
      final scrollingNotifier = position.isScrollingNotifier;

      void listener() {
        if (!scrollingNotifier.value) {
          final newIndex = pageController.page!.round();

          if (pageIndex.value != newIndex) {
            pageIndex.value = newIndex;
            align(context, newIndex, scrollController);
          }
        }
      }

      scrollingNotifier.addListener(listener);

      return () {
        scrollingNotifier.removeListener(listener);
      };
    }, [pageController, scrollController]);

    return Container(
      width: double.infinity,
      height: 80,
      color: colors.bg.black.withOpacity(GdsOpacity.opacity80),
      alignment: Alignment.center,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          vertical: GdsSpacing.spacing8,
          horizontal: context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20,
        ),
        separatorBuilder: (_, _) => SizedBox(width: GdsSpacing.spacing8),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          final isSelected = index == currentIndex;

          return ListenableBuilder(
            listenable: pageController,
            builder: (context, child) {
              final page = pageIndex.value.toDouble();

              double distance = (page - index).abs();
              double opacity = (1.0 - (distance * 0.5)).clamp(0.5, 1.0);

              return AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                curve: Curves.ease,
                opacity: opacity,
                child: child,
              );
            },
            child: GdsGesture(
              onTap: () {
                if (!isSelected) {
                  pageIndex.value = index;
                  pageController.animateToPage(index, duration: duration, curve: curve);
                  align(context, index, scrollController);
                }
              },
              child: GdsThumbnail(
                imageUrl: imageUrl,
                width: GdsSpacing.spacing64,
                height: GdsSpacing.spacing64,
                borderRadius: BorderRadius.circular(GdsRadius.lg),
              ),
            ),
          );
        },
      ),
    );
  }

  void align(BuildContext context, int index, ScrollController scrollController) {
    assert(pageController.page != null);
    assert(pageController.hasClients);
    assert(scrollController.hasClients);

    // 아이템 하나당 간격 포함 너비 (64 + 8 = 72)
    const itemWidth = GdsSpacing.spacing64 + GdsSpacing.spacing8;

    // 화면 너비
    final viewportWidth = scrollController.position.viewportDimension;

    // 좌측 패딩값
    final double leftPadding = context.isMobile ? GdsSpacing.spacing16 : GdsSpacing.spacing20;

    // 현재 page 위치 아이템의 중앙 좌표
    final itemCenter = leftPadding + (index * itemWidth) + (GdsSpacing.spacing64 / 2);

    // 아이템 중앙이 화면 중앙에 오도록 스크롤 타겟 위치 계산
    final targetOffset = itemCenter - (viewportWidth / 2);

    scrollController.animateTo(
      targetOffset.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: duration,
      curve: curve,
    );
  }
}
