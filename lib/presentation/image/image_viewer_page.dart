import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_cached_network_image.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/image/provider/image_save_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends HookConsumerWidget {
  const ImageViewerPage({super.key, required this.imageUrls, required this.initialIndex, this.enableSave = false});

  final List<String> imageUrls;
  final int initialIndex;
  final bool enableSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSingle = imageUrls.length <= 1;
    final currentIndex = useState(initialIndex);
    final pageController = usePageController(initialPage: initialIndex);
    final isSaving = ref.watch(imageSaveProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
            isSingle
                ? null
                : Row(
                  children: [
                    Text('${currentIndex.value + 1} ', style: AppTypeface.body1.copyWith(color: AppColor.main)),
                    Text('/ ${imageUrls.length}', style: AppTypeface.body1.copyWith(color: AppColor.gray00)),
                  ],
                ),
        actions: [
          if (enableSave)
            GrimityGesture(
              onTap:
                  isSaving ? null : () => ref.read(imageSaveProvider.notifier).saveByUrl(imageUrls[currentIndex.value]),
              child: Assets.icons.common.download.svg(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imageUrls.length,
                    onPageChanged: (index) => currentIndex.value = index,
                    itemBuilder: (context, index) {
                      return PhotoView(
                        imageProvider: CachedNetworkImageProvider(imageUrls[index]),
                        backgroundDecoration: BoxDecoration(color: Colors.transparent),
                      );
                    },
                  ),
                ),
                if (!isSingle)
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 32, left: 16),
                    child: SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == currentIndex.value;
                          return GrimityGesture(
                            onTap: () => pageController.jumpToPage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: isSelected ? Border.all(color: AppColor.main, width: 1) : null,
                              ),
                              child: GrimityCachedNetworkImage.cover(imageUrl: imageUrls[index], width: 48, height: 48),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Gap(6),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSaving) Center(child: GrimityCircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
