import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:grimity/presentation/board/board_view.dart';
import 'package:grimity/presentation/board/widget/board_app_bar.dart';
import 'package:grimity/presentation/board/widget/board_search_bar.dart';

class BoardPage extends ConsumerWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabList = [PostType.all, PostType.question, PostType.feedback];

    return BoardView(
      boardAppBar: BoardAppBar(),
      boardSearchBar: BoardSearchBar(),
      tabList: tabList,
    );
  }
}
