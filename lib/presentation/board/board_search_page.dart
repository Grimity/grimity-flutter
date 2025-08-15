import 'package:flutter/material.dart';
import 'package:grimity/presentation/board/board_search_view.dart';
import 'package:grimity/presentation/board/widget/board_search_app_bar.dart';
import 'package:grimity/presentation/board/widget/board_search_bar.dart';

class BoardSearchPage extends StatelessWidget {
  const BoardSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BoardSearchView(boardSearchAppBar: BoardSearchAppBar(), boardSearchBar: BoardSearchBar(isOnSearch: true));
  }
}
