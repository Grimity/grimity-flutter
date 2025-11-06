import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/album_organize/provider/album_organize_provider.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

class AlbumOrganizeFabButton extends ConsumerWidget with AlbumOrganizeMixin {
  const AlbumOrganizeFabButton({super.key, required this.title, required this.asset, required this.onTap});

  final String title;
  final SvgGenImage asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = albumOrganizeState(ref);
    final activeButton = state.ids.isNotEmpty && !state.uploading;

    return GrimityGesture(
      onTap: activeButton ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: activeButton ? AppColor.primary4 : AppColor.gray300,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: Row(
          children: [
            asset.svg(
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(activeButton ? AppColor.gray00 : AppColor.gray500, BlendMode.srcIn),
            ),
            Gap(10),
            Text(title, style: AppTypeface.caption1.copyWith(color: activeButton ? AppColor.gray00 : AppColor.gray500)),
          ],
        ),
      ),
    );
  }
}
