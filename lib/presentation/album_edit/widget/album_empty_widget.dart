import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';

class AlbumEmptyWidget extends StatelessWidget {
  const AlbumEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        spacing: 8,
        children: [
          Text('아직 생성된 앨범이 없어요', style: AppTypeface.subTitle3.copyWith(color: AppColor.gray700)),
          Text('앨범을 추가하면 그림을 분류할 수 있어요', style: AppTypeface.label2.copyWith(color: AppColor.gray500)),
        ],
      ),
    );
  }
}
