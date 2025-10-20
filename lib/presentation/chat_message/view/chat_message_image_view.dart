import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatMessageImageView extends StatelessWidget {
  const ChatMessageImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  final String imageUrl;
  final double? width;
  final double? height;

  /// 이미지를 불러올 때 임시로 정의될 이미지의 고유 크기.
  static const double tempSize = 240;

  @override
  Widget build(BuildContext context) {
    final w = width ?? tempSize;
    final h = width ?? tempSize;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Skeletonizer(child: SizedBox(width: w, height: h));
        },
        errorWidget: (context, error, stackTrace) {
          return Assets.images.imagePlaceholder.image(width: w, height: h);
        },
      ),
    );
  }
}