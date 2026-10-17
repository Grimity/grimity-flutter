import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/extensions/page_controller_extension.dart';
import 'package:pervice/pervice.dart';

/// 팔로잉 피드에 첨부된 이미지를 표시하며 좌우로 넘겨 볼 수 있는 위젯.
class FollowingFeedCarousel extends StatelessWidget {
  const new({
    super.key,
    required this.onTap,
    required this.images,
  });

  final ValueChanged<int> onTap;
  final List<ImageProvider> images;

  @override
  Widget build(BuildContext context) {
    final controller = context.usePageController();
    context.watch(controller);

    final index = controller.index;

    return GdsGesture(
      onTap: () => onTap(index),
      child: AspectRatio(
        aspectRatio: GdsThumbnailRatio.square.value,
        child: Stack(
          children: [
            // 이미지 표시
            PageView.builder(
              controller: controller,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GdsThumbnail(
                  ratio: .square,
                  provider: images[index],
                );
              },
            ),

            // 이미지가 여러 개인 경우 이동 컨트롤 표시.
            if (images.length > 1) ...[
              Positioned(
                bottom: 16,
                right: 16,
                child: GdsCounter(
                  size: .lg,
                  count: index + 1,
                  maxCount: images.length,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
