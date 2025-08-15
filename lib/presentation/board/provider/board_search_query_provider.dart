import 'package:grimity/app/enum/search_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_search_query_provider.g.dart';

part 'board_search_query_provider.freezed.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  SearchQueryState build() {
    return const SearchQueryState();
  }

  void updateSearchType(SearchType type) {
    state = state.copyWith(searchType: type);
  }

  void updateKeyword(String keyword) {
    state = state.copyWith(keyword: keyword);
  }
}

@freezed
abstract class SearchQueryState with _$SearchQueryState {
  const factory SearchQueryState({@Default(SearchType.combined) SearchType searchType, @Default('') String keyword}) =
      _SearchQueryState;
}
