import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCropButton extends ConsumerWidget {
  const ProfileCropButton({super.key, required this.controller});

  final CustomImageCropController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadImage = ref.read(uploadImageProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GrimityButton(
        uploadImage.type == UploadImageType.profile ? '프로필 저장' : '커버 저장',
        onTap: () async {
          final cropImage = await controller.onCropImage();

          if (cropImage != null) {
            await ref.read(uploadImageProvider.notifier).setMemoryImage(cropImage);
            await ref.read(uploadImageProvider.notifier).updateImage();
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
