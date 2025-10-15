import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_keyword_provider.g.dart';

@riverpod
class SearchKeyword extends _$SearchKeyword {
  @override
  String build() => '';

  void setKeyword(String keyword) => state = keyword;
}
