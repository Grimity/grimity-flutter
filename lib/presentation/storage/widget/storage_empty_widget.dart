import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/presentation/storage/provider/storage_tab_type_provider.dart';

class StorageEmptyWidget extends ConsumerWidget {
  const StorageEmptyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(storageTabProvider);

    return Column(
      spacing: 16.h,
      children: [SvgPicture.asset(Assets.icons.storage.resultNull.path, width: 60.w), Text(type.emptyMessage)],
    );
  }
}
