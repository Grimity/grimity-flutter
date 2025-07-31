import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/view/photo_selectable_image_view.dart';
import 'package:grimity/presentation/photo_select/view/photo_selected_image_view.dart';
import 'package:grimity/presentation/photo_select/widget/photo_permission_request_banner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoSelectBodyView extends HookConsumerWidget {
  const PhotoSelectBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(photoSelectProvider);
    return photos.maybeWhen(
      data: (state) {
        // 접근 권한이 없는 경우
        if (!state.hasAccess) {
          return _NoPermissionView();
        }

        // 이미지가 없는 경우
        if (state.photos.isEmpty) {
          return _NoSelectableImageView(isAuth: state.isAuth);
        }

        return Column(
          children: [
            // 선택적 권한인 경우 배너 표출
            if (!state.isAuth) PermissionRequestBanner(),
            if (state.selected.isNotEmpty) PhotoSelectedImageListView(state: state),
            Expanded(child: PhotoSelectableGridView(galleryImages: state.photos, selectedImages: state.selected)),
          ],
        );
      },
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}

/// 접근 권한이 없는 View
class _NoPermissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Assets.icons.common.warning.svg(width: 60, height: 60),
            Gap(16),
            Text('그림 첨부를 위해 접근 권한이 필요해요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
            Gap(8),
            Text('[설정 - 그리미티 - 사진]에서 “접근"을 허용해 주세요.', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
            Gap(16),
            GestureDetector(
              onTap: () => PhotoManager.openSetting(),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primary4),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  child: Text('사진 접근 권한 허용하기', style: AppTypeface.label2.copyWith(color: AppColor.gray00)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 접근 권한(전체, 선택)은 있는데 선택 가능한 이미지가 없는 View
class _NoSelectableImageView extends StatelessWidget {
  final bool isAuth;

  const _NoSelectableImageView({required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 선택적 권한인 경우 배너 표출
        if (!isAuth) PermissionRequestBanner(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(
            child: Column(
              children: [
                Assets.icons.common.resultNull.svg(width: 60, height: 60),
                Gap(16),
                Text('아직 업로드 할 그림이 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
