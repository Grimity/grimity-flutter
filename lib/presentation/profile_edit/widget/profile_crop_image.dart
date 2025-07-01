import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCropImage extends ConsumerWidget {
  const ProfileCropImage({super.key, required this.controller, required this.type});

  final CustomImageCropController controller;
  final UploadImageType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadImage = ref.read(uploadImageProvider(type));

    return Expanded(
      child: CustomImageCrop(
        canRotate: false,
        image: FileImage(File(uploadImage.image!.path)),
        cropController: controller,
        drawPath: SolidCropPathPainter.drawPath,
        pathPaint:
            Paint()
              ..color = Colors.white
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
        forceInsideCropArea: true,
        backgroundColor: Colors.black,
        shape: uploadImage.type == UploadImageType.profile ? CustomCropShape.Circle : CustomCropShape.Square,
        ratio:
            uploadImage.type == UploadImageType.profile ? Ratio(width: 1, height: 1) : Ratio(width: 365, height: 156),
      ),
    );
  }
}
