import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/image/view/image_viewer_app_bar.dart';
import 'package:grimity/presentation/image/view/image_viewer_body_view.dart';

class ImageViewerPage extends HookWidget {
  const ImageViewerPage({super.key, required this.imageUrls, required this.initialIndex, this.enableSave = false});

  final List<String> imageUrls;
  final int initialIndex;
  final bool enableSave;

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(initialIndex);
    final pageController = usePageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: GdsColors.black,
      appBar: ImageViewerAppBar(
        imageUrls: imageUrls,
        currentIndex: currentIndex.value,
        enableSave: enableSave,
      ),
      body: ImageViewerBodyView(
        imageUrls: imageUrls,
        currentIndex: currentIndex.value,
        pageController: pageController,
        onPageChanged: (index) => currentIndex.value = index,
      ),
    );
  }
}
