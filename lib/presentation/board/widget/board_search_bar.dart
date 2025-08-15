import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:grimity/presentation/board/widget/board_search_by_dropdown.dart';
import 'package:grimity/presentation/common/widget/grimity_text_field.dart';

class BoardSearchBar extends StatelessWidget {
  const BoardSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: AppColor.gray100),
      child: Row(
        spacing: 6,
        children: [
          /// TODO Search 동작 구현
          SizedBox(width: 110.w, child: BoardSearchByDropdown(type: SearchType.combined, onChanged: (p0) {})),
          Expanded(
            child: GrimityTextField.small(hintText: '검색어를 입력해주세요.', maxLines: 1, showSearchIcon: true, onSearch: () {}),
          ),
        ],
      ),
    );
  }
}
