import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/storage/enum/storage_enum_item.dart';
import 'package:grimity/presentation/storage/provider/storage_tab_type_provider.dart';

class StorageTabChip extends ConsumerWidget {
  final StorageTabType type;

  const StorageTabChip({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(storageTabProvider);
    final isSelected = type == selectedType;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isSelected ? null : () => ref.read(storageTabProvider.notifier).changeTab(type),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.gray700 : AppColor.gray00,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColor.gray300, width: 1),
        ),
        child: Text(
          type.title,
          style:
              isSelected
                  ? AppTypeface.label1.copyWith(color: AppColor.gray00)
                  : AppTypeface.label2.copyWith(color: AppColor.gray700),
        ),
      ),
    );
  }
}
