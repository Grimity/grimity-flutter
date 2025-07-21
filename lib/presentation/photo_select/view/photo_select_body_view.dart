import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/grimity_circular_progress_indicator.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/view/photo_selectable_image_view.dart';
import 'package:grimity/presentation/photo_select/view/photo_selected_image_view.dart';
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

        // 선택적 접근 권한, 이미지가 없는 경우
        if (!state.isAuth && state.photos.isEmpty) {
          return _NoSelectableImageView();
        }

        // 전체 접근 권한, 이미지가 없는 경우
        if (state.photos.isEmpty) {
          return Center(child: Text('이미지가 없습니다.'));
        }

        return Column(
          children: [
            if (state.selected.isNotEmpty) PhotoSelectedImageListView(state: state),
            Expanded(child: PhotoSelectableGridView(galleryImages: state.photos, selectedImages: state.selected)),
          ],
        );
      },
      orElse: () => GrimityCircularProgressIndicator(),
    );
  }
}

class _NoPermissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('이미지 선택 권한이 없습니다'),
          ElevatedButton(onPressed: () => PhotoManager.openSetting(), child: Text('권한 설정하기')),
        ],
      ),
    );
  }
}

class _NoSelectableImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('선택된 이미지가 없습니다.'),
          ElevatedButton(onPressed: () => PhotoManager.openSetting(), child: Text('이미지 설정하기')),
        ],
      ),
    );
  }
}
