import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/album.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/feed_upload/provider/feed_upload_provider.dart';

showSelectAlbumBottomSheet(BuildContext context, WidgetRef ref, List<Album> albums) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(maxHeight: 520.h),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(24),
            Row(
              children: [
                Text("앨범 선택", style: AppTypeface.subTitle3),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Assets.icons.common.close.svg(width: 24, height: 24),
                ),
              ],
            ),
            Gap(24),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children:
                    albums.map((e) {
                      return _AlbumSelectBottomSheetButton(
                        title: e.name,
                        onTap: () {
                          context.pop();
                          ref.read(feedUploadProvider.notifier).updateAlbumId(e.id);
                        },
                        isSelected: e.id == ref.read(feedUploadProvider).albumId,
                      );
                    }).toList(),
              ),
            ),
            Gap(24),
          ],
        ),
      );
    },
  );
}

class _AlbumSelectBottomSheetButton extends StatelessWidget {
  const _AlbumSelectBottomSheetButton({required this.title, required this.onTap, required this.isSelected});

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  Color get _borderColor => isSelected ? AppColor.main : AppColor.gray300;

  Color get _boxColor => isSelected ? AppColor.mainSecondary : AppColor.gray00;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
          color: _boxColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypeface.label2.copyWith(color: AppColor.gray800)),
            if (isSelected) Assets.icons.common.checkMark.svg(),
          ],
        ),
      ),
    );
  }
}
