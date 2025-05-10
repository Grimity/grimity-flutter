import 'package:flutter/material.dart';
import 'package:grimity/gen/assets.gen.dart';

class HomeNoticeView extends StatelessWidget {
  const HomeNoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Assets.images.noticeBanner.image());
  }
}
