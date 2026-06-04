import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/presentation/board/view/board_view.dart';
import 'package:grimity/presentation/common/widget/navigation/grimity_main_top_navigation.dart';

class BoardPage extends ConsumerWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabList = [PostType.all, PostType.question, PostType.feedback];

    return GdsScaffold(
      appBar: GrimityMainTopNavigation(),
      body: BoardView(tabList: tabList),
    );
  }
}
