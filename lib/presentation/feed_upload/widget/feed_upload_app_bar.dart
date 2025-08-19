import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/widget/grimity_select_modal_bottom_sheet.dart';
import 'package:grimity/presentation/feed_upload/provider/album_list_provider.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_cancel_dialog.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_complete_dialog.dart';
import 'package:grimity/presentation/feed_upload/widget/feed_upload_modal_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedUploadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedUploadAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppTheme.kToolbarHeight.height,
      leading: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => showCancelFeedUploadDialog(context),
          child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
        ),
      ),
      title: Consumer(
        builder: (context, ref, child) {
          final albumListAsync = ref.watch(albumListProvider);

          return albumListAsync.when(
            data: (albums) {
              final selectedAlbum = albums.firstWhere((e) => e.id == ref.watch(feedUploadProvider).albumId);

              return GestureDetector(
                onTap:
                    () => GrimitySelectModalBottomSheet.show(
                      context,
                      title: '앨범 선택',
                      buttons:
                          albums
                              .map(
                                (e) => GrimitySelectModalButtonModel(
                                  title: e.name,
                                  isSelected: e.id == ref.read(feedUploadProvider).albumId,
                                  onTap: () {
                                    context.pop();
                                    ref.read(feedUploadProvider.notifier).updateAlbumId(e.id);
                                  },
                                ),
                              )
                              .toList(),
                    ),
                child: Row(
                  children: [Text(selectedAlbum.name, style: AppTypeface.subTitle3), Icon(Icons.expand_more, size: 24)],
                ),
              );
            },
            error: (error, stackTrace) {
              return Skeletonizer(child: Text('전체 앨범', style: AppTypeface.subTitle3));
            },
            loading: () {
              return Skeletonizer(child: Text('전체 앨범', style: AppTypeface.subTitle3));
            },
          );
        },
      ),
      titleSpacing: 0,
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final feedUploadState = ref.watch(feedUploadProvider);
            final canFeedUpload =
                feedUploadState.title.trim().isNotEmpty &&
                feedUploadState.content.trim().isNotEmpty &&
                feedUploadState.images.isNotEmpty;

            return TextButton(
              onPressed:
                  canFeedUpload
                      ? () async {
                        final uploadedFeedUrl = await ref.read(feedUploadProvider.notifier).feedUpload();
                        if (uploadedFeedUrl != null && context.mounted) {
                          showUploadCompleteDialog(context, uploadedFeedUrl);
                        }
                      }
                      : null,
              child: Text(
                '등록',
                style: AppTypeface.subTitle4.copyWith(color: canFeedUpload ? AppColor.main : AppColor.gray500),
              ),
            );
          },
        ),
      ],
      actionsPadding: EdgeInsets.zero,
    );
  }

  @override
  Size get preferredSize => AppTheme.kToolbarHeight;
}
