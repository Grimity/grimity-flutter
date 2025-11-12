import 'package:flutter/material.dart';
import 'package:grimity/presentation/search/search_view.dart';
import 'package:grimity/presentation/search/view/search_feed_tab_view.dart';
import 'package:grimity/presentation/search/view/search_post_tab_view.dart';
import 'package:grimity/presentation/search/view/search_recommend_tag_view.dart';
import 'package:grimity/presentation/search/view/search_user_tab_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.keyword});

  final String? keyword;

  @override
  Widget build(BuildContext context) {
    return SearchView(
      initialKeyword: keyword,
      recommendTagView: SearchRecommendTagView(),
      searchFeedTabView: SearchFeedTabView(),
      searchUserTabView: SearchUserTabView(),
      searchPostTabView: SearchPostTabView(),
    );
  }
}
