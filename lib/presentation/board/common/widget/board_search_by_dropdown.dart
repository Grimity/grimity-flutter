import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/gen/assets.gen.dart';

class BoardSearchByDropdown extends StatelessWidget {
  const BoardSearchByDropdown({super.key, required this.type, required this.onChanged});

  final SearchType type;
  final Function(SearchType?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SearchType>(
      value: type,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColor.gray00,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
      ),
      dropdownColor: AppColor.gray00,
      borderRadius: BorderRadius.circular(8),
      icon: Assets.icons.common.arrowDown.svg(
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(AppColor.gray700, BlendMode.srcIn),
      ),
      items:
          SearchType.values.map((e) {
            return DropdownMenuItem<SearchType>(
              value: e,
              child: Text(e.typeName, style: AppTypeface.label2.copyWith(color: AppColor.gray800)),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
