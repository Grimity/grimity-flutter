import 'package:flutter/material.dart';
import 'package:grimity/presentation/search/search_view.dart';
import 'package:grimity/presentation/search/view/search_feed_tab_view.dart';
import 'package:grimity/presentation/search/view/search_recommend_tag_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchView(
      recommendTagView: SearchRecommendTagView(),
      searchFeedTabView: SearchFeedTabView(),
      searchUserTabView: Placeholder(),
      searchPostTabView: Placeholder(),
    );
  }
}
