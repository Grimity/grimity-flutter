import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/system/image_crop/grimity_image_crop_view.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';

class GrimityImageCropPopup {
  const GrimityImageCropPopup({
    required this.title,
    required this.label,
    required this.imageType,
    required this.shape,
    required this.ratio,
  });

  final String title;
  final String label;
  final UploadImageType imageType;
  final CustomCropShape shape;
  final double ratio;

  Future<void> show(BuildContext context, WidgetRef ref) {
    final container = ProviderScope.containerOf(context);
    final controller = CustomImageCropController();

    final view = GrimityImageCropView(
      imageType: imageType,
      ratio: ratio,
      shape: shape,
      controller: controller,
    );

    final modal = GdsModal(
      title: title,
      body: view,
      primaryLabel: label,
      onPrimary: () => save(context, container, imageType, controller),
    );

    return modal.open(context);
  }

  static Future<void> save(
    BuildContext context,
    ProviderContainer container,
    UploadImageType imageType,
    CustomImageCropController controller,
  ) async {
    final notifier = container.read(uploadImageProvider(imageType).notifier);
    final image = await controller.onCropImage();
    if (image == null) {
      ToastService.showFailure('이미지 수정 과정에서 문제가 발생했어요');
      return;
    }

    await notifier.setMemoryImage(image);
    notifier.updateImage();

    if (context.mounted) {
      context.pop();
    }
  }
}
