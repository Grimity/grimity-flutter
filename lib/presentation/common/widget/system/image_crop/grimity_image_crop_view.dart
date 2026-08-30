import 'dart:io';
import 'dart:ui' as ui;

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GrimityImageCropView extends HookConsumerWidget {
  const GrimityImageCropView({
    super.key,
    required this.imageType,
    required this.ratio,
    required this.shape,
    required this.controller,
  });

  final UploadImageType imageType;
  final double ratio;
  final CustomCropShape shape;
  final CustomImageCropController controller;

  /// 이미지 파일의 고유 크기를 반환합니다.
  Future<ui.Size> _getImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return ui.Size(frame.image.width.toDouble(), frame.image.height.toDouble());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadImageProvider(imageType));
    final file = File(state.image!.path);

    // 이미지의 원본 비율을 저장할 state (초기값은 임시로 1.0)
    final imageRatioState = useState<double?>(null);

    useEffect(() {
      _getImageSize(file).then((size) {
        imageRatioState.value = size.width / size.height;
      });
      return null;
    }, [file.path]);

    useEffect(() {
      return () => controller.dispose();
    }, [controller]);

    if (imageRatioState.value == null) {
      return const Center(child: GdsCircularLoading());
    }

    return AspectRatio(
      aspectRatio: imageRatioState.value!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GdsRadius.sm),
        child: CustomImageCrop(
          canRotate: false,
          image: FileImage(file),
          cropController: controller,
          drawPath: SolidCropPathPainter.drawPath,
          pathPaint: Paint()
            ..color = GdsColors.blue60
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
          overlayColor: GdsColors.black.withOpacity(0.7),
          cropPercentage: 1.0,
          forceInsideCropArea: true,
          backgroundColor: GdsColors.black,
          shape: shape,
          ratio: Ratio(width: ratio, height: 1.0),
        ),
      ),
    );
  }
}
