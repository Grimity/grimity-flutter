import 'package:grimity/app/enum/search_type.enum.dart';

class SearchPostsParam {
  final int page;
  final int size;
  final String keyword;
  final SearchType searchType;

  const SearchPostsParam({
    required this.page,
    required this.size,
    required this.keyword,
    required this.searchType,
  });
}