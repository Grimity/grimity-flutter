import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_page_argument_provider.dart';
import 'package:grimity/presentation/post_upload/provider/post_upload_provider.dart';

class ImageDeleteToolbar extends ConsumerWidget {
  const ImageDeleteToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postUploadProvider);
    final notifier = ref.read(postUploadProvider.notifier);
    final deletable = state.selectedImageUrls.isEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.gray00,
        border: Border(top: BorderSide(color: AppColor.gray300, width: 1)),
      ),
      height: 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GrimityGesture(
            onTap: () => notifier.updateImageEdit(false),
            child: Text('취소', style: AppTypeface.label3.copyWith(color: AppColor.gray700)),
          ),
          GrimityGesture(
            onTap:
                deletable
                    ? null
                    : () => ref
                        .read(postUploadProvider.notifier)
                        .deleteSelectedImage(ref.read(postUploadQuillControllerArgumentProvider)),
            child: Text(
              '삭제',
              style: AppTypeface.label3.copyWith(color: deletable ? AppColor.gray500 : AppColor.accentRed),
            ),
          ),
        ],
      ),
    );
  }
}
