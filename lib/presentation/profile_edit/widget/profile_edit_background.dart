import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_image_crop_popup.dart';
import 'package:grimity/presentation/common/widget/system/profile/grimity_profile_background_image.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';

class ProfileEditBackground extends ConsumerWidget {
  const ProfileEditBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = UploadImageType.background;
    final colors = context.gdsColors;
    final profileEditState = ref.watch(profileEditProvider);
    final uploadImageState = ref.watch(uploadImageProvider(type));
    final uploadImage = ref.read(uploadImageProvider(type).notifier);

    return Stack(
      children: [
        GrimityProfileBackgroundImage(url: profileEditState.backgroundImage),

        Positioned.fill(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: GdsSpacing.spacing8,
              children: [
                GdsIconButton.solid(
                  icon: GdsIcon.cameraOutline,
                  onPressed: () async {
                    final isSelected = await uploadImage.pickImage(type);

                    if (isSelected && context.mounted) {
                      final popup = GrimityImageCropPopup(
                        title: '프로필 커버 수정',
                        label: '커버 저장',
                        imageType: type,
                        ratio: GdsThumbnailRatio.r4x1.value,
                        shape: CustomCropShape.Square,
                      );

                      popup.show(context, ref);
                    }
                  },
                ),
                GdsIconButton.solid(
                  icon: GdsIcon.xMark,
                  enabled: profileEditState.backgroundImage != null,
                  onPressed: () => uploadImage.deleteImage(type),
                ),
              ],
            ),
          ),
        ),

        if (uploadImageState.isUploading) ...[
          Positioned.fill(
            child: Container(
              color: colors.bg.black.withOpacity(GdsOpacity.opacity40),
              child: Center(child: GdsCircularLoading()),
            ),
          ),
        ],
      ],
    );
  }
}
