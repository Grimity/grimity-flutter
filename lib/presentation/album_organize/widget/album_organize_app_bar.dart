import 'package:flutter/widgets.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_title_top_navigation.dart';

class AlbumOrganizeAppBar extends StatelessWidget {
  const AlbumOrganizeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GrimityTitleTopNavigation(title: '그림 정리');
  }
}
