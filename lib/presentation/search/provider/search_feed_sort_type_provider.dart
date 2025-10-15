import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_feed_sort_type_provider.g.dart';

@riverpod
class SearchFeedSortType extends _$SearchFeedSortType {
  @override
  SortType build() => SortType.accuracy;

  void update(SortType sortType) {
    if (state == sortType) return;
    state = sortType;
  }
}
