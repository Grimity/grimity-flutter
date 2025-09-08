import 'package:freezed_annotation/freezed_annotation.dart';

import '../../app/enum/sort_type.enum.dart';

part 'search_feeds_param.freezed.dart';

@freezed
abstract class SearchFeedsParam with _$SearchFeedsParam {
  const factory SearchFeedsParam({
    required String keyword,
    required SortType sort,
    required int size,
    String? cursor,
  }) = _SearchFeedsParam;
}