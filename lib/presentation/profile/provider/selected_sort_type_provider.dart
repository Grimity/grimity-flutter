import 'package:grimity/app/enum/sort_type.enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_sort_type_provider.g.dart';

@riverpod
class SelectedSortType extends _$SelectedSortType {
  @override
  SortType build() {
    return SortType.latest;
  }

  void setSortType(SortType sortType) {
    state = sortType;
  }
}
