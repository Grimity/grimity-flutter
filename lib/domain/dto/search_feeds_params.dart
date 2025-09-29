import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/enum/sort_type.enum.dart';

part 'search_feeds_params.freezed.dart';

@freezed
abstract class SearchFeedsParams with _$SearchFeedsParams {
  const factory SearchFeedsParams({
    required String keyword,
    required SortType sort,
    required int size,
    String? cursor,
  }) = _SearchFeedsParams;
}