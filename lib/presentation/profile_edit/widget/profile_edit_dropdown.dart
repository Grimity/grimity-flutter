import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/gen/assets.gen.dart';

class ProfileEditDropdown extends StatelessWidget {
  const ProfileEditDropdown({super.key, required this.link, required this.onChanged});

  final Link link;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: link.linkName,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        isDense: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.gray300),
        ),
      ),
      style: AppTypeface.label2,
      dropdownColor: AppColor.gray00,
      icon: Assets.icons.profileEdit.arrowDown.svg(width: 16, height: 16),
      items:
          ['X', '인스타그램', '픽시브', '유튜브', '이메일'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value, style: AppTypeface.label2));
          }).toList(),
      onChanged: onChanged,
    );
  }
}
