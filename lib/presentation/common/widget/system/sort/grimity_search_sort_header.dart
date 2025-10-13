import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:grimity/gen/assets.gen.dart';

class GrimitySearchSortHeader extends StatelessWidget {
  const GrimitySearchSortHeader({
    super.key,
    this.resultCount,
    this.onOrganizeTap,
    this.sortValue,
    this.sortItems,
    this.onSortChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  /// 검색 결과 개수 (null이 아닌 경우만 표시)
  final int? resultCount;

  /// 그림 정리 tap 이벤트 (null이 아닌 경우만 표시)
  final VoidCallback? onOrganizeTap;

  /// 정렬 dropdown (sortValue, sortItems, onSortChanged가 null이 아닐때만 표시)
  final SortType? sortValue;
  final List<DropdownMenuItem<SortType>>? sortItems;
  final ValueChanged<SortType?>? onSortChanged;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: 44,
      child: Row(
        children: [
          if (resultCount != null) _SearchResultCount(count: resultCount!),
          Spacer(),
          Row(
            spacing: 16,
            children: [
              if (onOrganizeTap != null) _ArrangeButton(onTap: onOrganizeTap!),
              if (sortValue != null && sortItems != null && onSortChanged != null)
                _SortDropdown(sortValue: sortValue!, sortItems: sortItems!, onSortChanged: onSortChanged!),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchResultCount extends StatelessWidget {
  const _SearchResultCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '검색결과 ', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
          TextSpan(text: count.toString(), style: AppTypeface.label2.copyWith(color: AppColor.gray800)),
          TextSpan(text: '건', style: AppTypeface.label2.copyWith(color: AppColor.gray600)),
        ],
      ),
    );
  }
}

class _ArrangeButton extends StatelessWidget {
  const _ArrangeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        spacing: 6,
        children: [
          Text('그림 정리', style: AppTypeface.caption2.copyWith(color: AppColor.gray700)),
          Assets.icons.common.sync.svg(width: 16, height: 16),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.sortValue, required this.sortItems, required this.onSortChanged});

  final SortType sortValue;
  final List<DropdownMenuItem<SortType>> sortItems;
  final ValueChanged<SortType?> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DropdownButtonFormField<SortType>(
        value: sortValue,
        items: sortItems,
        onChanged: onSortChanged,
        isDense: true,
        decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        dropdownColor: AppColor.gray00,
        borderRadius: BorderRadius.circular(12),
        icon: Assets.icons.common.arrowDown.svg(width: 16, height: 16),
      ),
    );
  }
}
