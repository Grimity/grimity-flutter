import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_modal_bottom_sheet.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';

class ProfileEditProfileImage extends ConsumerWidget {
  const ProfileEditProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.watch(uploadImageProvider(UploadImageType.profile)).isUploading;

    return Positioned.fill(
      top: -40,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: isUploading ? null : () => _showProfileImageBottomSheet(context, ref),
          child: Stack(
            children: [
              GrimityProfileImage(url: ref.watch(profileEditProvider).image),
              if (isUploading) ...[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.3)),
                    child: GrimityCircularProgressIndicator(),
                  ),
                ),
              ] else ...[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border.all(color: Colors.white, width: 4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Assets.icons.profileEdit.camera.svg(width: 30, height: 30)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileImageBottomSheet(BuildContext context, WidgetRef ref) {
    final type = UploadImageType.profile;
    final uploadImage = ref.read(uploadImageProvider(type).notifier);

    final List<GrimityModalButtonModel> buttons = [
      GrimityModalButtonModel(
        title: '기본 프로필로 변경',
        onTap: () async {
          await uploadImage.deleteImage(type);

          if (context.mounted) {
            context.pop();
          }
        },
      ),
      GrimityModalButtonModel(
        title: '프로필 변경',
        onTap: () async {
          final isSelected = await uploadImage.pickImage(type);

          if (isSelected && context.mounted) {
            context.pop();
            CropImageRoute(type: type).push(context);
          }
        },
      ),
    ];

    GrimityModalBottomSheet.show(context, buttons: buttons);
  }
}
