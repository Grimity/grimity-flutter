import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/grimity_button.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCropButton extends ConsumerWidget {
  const ProfileCropButton({super.key, required this.controller, required this.type});

  final CustomImageCropController controller;
  final UploadImageType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadImage = ref.read(uploadImageProvider(type));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GrimityButton(
        uploadImage.type == UploadImageType.profile ? '프로필 저장' : '커버 저장',
        onTap: () async {
          final cropImage = await controller.onCropImage();

          if (cropImage != null) {
            await ref.read(uploadImageProvider(type).notifier).setMemoryImage(cropImage);
            // updateImage의 시간이 너무 오래걸려서 비동기로 처리
            // isUploading으로 상태 관리
            ref.read(uploadImageProvider(type).notifier).updateImage();
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
