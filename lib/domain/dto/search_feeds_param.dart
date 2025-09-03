import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_feeds_param.freezed.dart';

@freezed
abstract class SearchFeedsParam with _$SearchFeedsParam {
  const factory SearchFeedsParam({
    required String keyword,
    @Default('latest') String sort, // latest | popular | accuracy
    @Default(10) int size,
    String? cursor,
  }) = _SearchFeedsParam;
}