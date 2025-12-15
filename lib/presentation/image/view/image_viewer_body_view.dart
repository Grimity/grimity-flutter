import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerBodyView extends StatelessWidget {
  const ImageViewerBodyView({
    super.key,
    required this.imageUrls,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
  });

  final List<String> imageUrls;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

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

              if (isSaving) return Center(child: GrimityCircularProgressIndicator());

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
  });

  final List<String> imageUrls;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: imageUrls.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrls[index]),
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        );
      },
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
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32, left: 16),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final isSelected = index == currentIndex;
            return GrimityGesture(
              onTap: () => pageController.jumpToPage(index),
              child: Container(
                decoration: BoxDecoration(
                  border: isSelected ? Border.all(color: AppColor.main, width: 1) : null,
                ),
                child: GrimityCachedNetworkImage.cover(
                  imageUrl: imageUrls[index],
                  width: 48,
                  height: 48,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Gap(6),
        ),
      ),
    );
  }
}
