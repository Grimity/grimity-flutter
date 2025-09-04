import 'package:grimity/app/enum/search_post_type.enum.dart';

class SearchPostsParam {
  final int page;
  final int size;
  final String keyword;
  final SearchBy searchBy;

  const SearchPostsParam({
    required this.page,
    required this.size,
    required this.keyword,
    required this.searchBy,
  });
}
