import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/common/dialog/cancel_upload_dialog.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_select_modal_bottom_sheet.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';
import 'package:grimity/presentation/post_upload/widget/post_upload_complete_dialog.dart';

class PostUploadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostUploadAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppTheme.kToolbarHeight.height,
      leading: Center(
        child: GrimityGesture(
          onTap: () => showCancelUploadDialog(context),
          child: Assets.icons.common.close.svg(width: 24.w, height: 24.w),
        ),
      ),
      title: Consumer(
        builder: (context, ref, child) {
          final type = ref.watch(postUploadProvider).type;

          return GrimityGesture(
            onTap: () {
              GrimitySelectModalBottomSheet.show(
                context,
                title: '카테고리 선택',
                buttons:
                    [PostType.normal, PostType.question, PostType.feedback]
                        .map(
                          (e) => GrimitySelectModalButtonModel(
                            title: e.typeName,
                            isSelected: e == type,
                            onTap: () {
                              context.pop();
                              ref.read(postUploadProvider.notifier).updateType(e);
                            },
                          ),
                        )
                        .toList(),
              );
            },
            child: Row(
              children: [Text(type.typeName, style: AppTypeface.subTitle3), Icon(Icons.expand_more, size: 24)],
            ),
          );
        },
      ),
      titleSpacing: 0,
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final canUpload = ref.watch(postUploadProvider).canUpload;

            return TextButton(
              onPressed:
                  canUpload
                      ? () async {
                        final uploadedPost = await ref
                            .read(postUploadProvider.notifier)
                            .postUpload(ref.read(postUploadQuillControllerArgumentProvider));
                        if (uploadedPost != null && context.mounted) {
                          showUploadCompleteDialog(context, uploadedPost);
                        }
                      }
                      : null,
              child: Text(
                '등록',
                style: AppTypeface.subTitle4.copyWith(color: canUpload ? AppColor.main : AppColor.gray500),
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
