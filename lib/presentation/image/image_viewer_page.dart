import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends HookWidget {
  const ImageViewerPage({super.key, required this.imageUrls, required this.initialIndex});

  final List<String> imageUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(initialIndex);
    final pageController = usePageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Assets.icons.common.close.svg(
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(AppColor.gray00, BlendMode.srcIn),
            ),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Text('${currentIndex.value + 1} ', style: AppTypeface.body1.copyWith(color: AppColor.main)),
            Text('/ ${imageUrls.length}', style: AppTypeface.body1.copyWith(color: AppColor.gray00)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
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
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 32.h, left: 16.h),
              child: SizedBox(
                height: 48.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == currentIndex.value;
                    return GestureDetector(
                      onTap: () => pageController.jumpToPage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: isSelected ? Border.all(color: AppColor.main, width: 1) : null,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          width: 48.h,
                          height: 48.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
