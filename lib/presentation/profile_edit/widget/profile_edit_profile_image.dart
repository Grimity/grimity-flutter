import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_image_crop_popup.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_menu_popup.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';

class ProfileEditProfileImage extends ConsumerWidget {
  const ProfileEditProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = UploadImageType.profile;
    final colors = context.gdsColors;
    final profileEditState = ref.watch(profileEditProvider);
    final uploadImageState = ref.watch(uploadImageProvider(type));
    final isUploading = uploadImageState.isUploading;

    return FractionalTranslation(
      translation: Offset(0, -0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GdsPersonAvatar(
                size: GdsAvatarSize.lg,
                imageUrl: profileEditState.image,
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: colors.surface.base,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              if (isUploading) ...[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.bg.black.withOpacity(GdsOpacity.opacity40),
                    ),
                    child: Center(child: GdsCircularLoading()),
                  ),
                ),
              ],
            ],
          ),
          FractionalTranslation(
            translation: Offset(-0.7, 0),
            child: GdsMenuAnchor(
              builder: (link) {
                return GdsIconButton.solid(
                  icon: GdsIcon.cameraOutline,
                  enabled: !isUploading,
                  onPressed: () => _showProfileImageBottomSheet(context, ref, link),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfileImageBottomSheet(
    BuildContext context,
    WidgetRef ref,
    LayerLink link,
  ) {
    final type = UploadImageType.profile;
    final state = ref.read(profileEditProvider);
    final notifier = ref.read(uploadImageProvider(type).notifier);

    final items = [
      if (state.image != null) ...[
        GdsMenuItem(
          label: '기본 프로필로 변경',
          onTap: () {
            context.pop();
            notifier.deleteImage(type);
          },
        ),
      ],
      GdsMenuItem(
        label: '사진으로 변경',
        onTap: () async {
          context.pop();
          final isSelected = await notifier.pickImage(type);

          if (isSelected && context.mounted) {
            final popup = GrimityImageCropPopup(
              title: '프로필 이미지 수정',
              label: '프로필 저장',
              imageType: type,
              shape: CustomCropShape.Circle,
              ratio: GdsThumbnailRatio.r1x1.value,
            );

            popup.show(context, ref);
          }
        },
      ),
    ];

    final popup = GrimityMenuPopup(layerLink: link, items: items);

    return popup.show(context, GdsMenuPosition.left);
  }
}
