import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatMessageImageView extends StatelessWidget {
  const ChatMessageImageView({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  /// 이미지를 불러올 때 임시로 정의될 이미지의 고유 크기.
  static const double tempSize = 240;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) {
          return Skeletonizer(child: SizedBox(width: tempSize, height: tempSize));
        },
        errorWidget: (context, error, stackTrace) {
          return Assets.images.imagePlaceholder.image(width: tempSize, height: tempSize);
        },
      ),
    );
  }
}