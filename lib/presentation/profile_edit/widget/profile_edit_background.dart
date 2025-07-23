import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_placeholder.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_edit_bottom_sheet.dart';

class ProfileEditBackground extends ConsumerWidget {
  const ProfileEditBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundImage = ref.watch(profileEditProvider).backgroundImage;

    return Stack(
      children: [
        GrimityProfileBackgroundImage(url: backgroundImage),
        _ProfileEditBackgroundEditButton(),
        if (ref.read(uploadImageProvider(UploadImageType.background)).isUploading)
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3), child: GrimityCircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _ProfileEditBackgroundEditButton extends ConsumerWidget {
  const _ProfileEditBackgroundEditButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.read(uploadImageProvider(UploadImageType.background)).isUploading;

    return Positioned.fill(
      right: 16,
      bottom: 16,
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: isUploading ? null : () => showBackgroundImageBottomSheet(context, ref),
          child: Container(
            width: 69.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColor.gray00,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: AppColor.gray300),
            ),
            child: Center(child: Text("커버 변경", style: AppTypeface.caption2)),
          ),
        ),
      ),
    );
  }
}
