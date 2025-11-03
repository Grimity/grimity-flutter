import 'package:flutter/material.dart';
import 'package:grimity/presentation/common/widget/grimity_infinite_scroll_pagination.dart';
import 'package:grimity/presentation/common/widget/grimity_loading_indicator.dart';
import 'package:grimity/presentation/common/widget/grimity_state_view.dart';
import 'package:grimity/presentation/photo_select/provider/photo_select_provider.dart';
import 'package:grimity/presentation/photo_select/view/photo_selectable_image_view.dart';
import 'package:grimity/presentation/photo_select/view/photo_selected_image_view.dart';
import 'package:grimity/presentation/photo_select/widget/photo_permission_request_banner.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoSelectBodyView extends HookConsumerWidget with PhotoSelectMixin {
  const PhotoSelectBodyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return photosAsync(ref).when(
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
            Expanded(
              child: GrimityInfiniteScrollPagination(
                isEnabled: state.hasMore,
                onLoadMore: photoNotifier(ref).loadMore,
                child: PhotoSelectableGridView(galleryImages: state.photos, selectedImages: state.selected),
              ),
            ),
          ],
        );
      },
      loading: () => GrimityLoadingIndicator(),
      error: (e, s) => GrimityStateView.error(onTap: () => invalidatePhotoSelect(ref)),
    );
  }
}

/// 접근 권한이 없는 View
class _NoPermissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GrimityStateView.warning(
      title: '그림 첨부를 위해 접근 권한이 필요해요',
      subTitle: '[설정 - 그리미티 - 사진]에서 “접근"을\n허용해 주세요.',
      buttonText: '사진 접근 권한 허용하기',
      onTap: () => PhotoManager.openSetting(),
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
        GrimityStateView.resultNull(title: '아직 업로드 할 그림이 없어요'),
      ],
    );
  }
}
