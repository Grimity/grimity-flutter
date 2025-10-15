import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/gen/assets.gen.dart';

class SearchEmptyWidget extends StatelessWidget {
  const SearchEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        spacing: 16,
        children: [
          Assets.icons.common.resultNull.svg(width: 60, height: 60),
          Column(
            spacing: 6,
            children: [
              Text('검색 결과가 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
              Text('다른 검색어를 입력해보세요', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
            ],
          ),
        ],
      ),
    );
  }
}
