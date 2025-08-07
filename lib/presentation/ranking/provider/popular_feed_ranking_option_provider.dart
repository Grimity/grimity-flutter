import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_feed_ranking_option_provider.g.dart';

part 'popular_feed_ranking_option_provider.freezed.dart';

@riverpod
class PopularFeedRankingOption extends _$PopularFeedRankingOption {
  @override
  PopularRankingOption build() {
    final now = DateTime.now();
    return PopularRankingOption(baseDate: DateTime(now.year, now.month, now.day));
  }

  void setType(FeedRankingType type) {
    if (type == state.type) return;
    final now = DateTime.now();
    state =
        type == FeedRankingType.weekly
            ? state.copyWith(type: type, baseDate: DateTime(now.year, now.month, now.day))
            : state.copyWith(type: type, baseDate: DateTime(now.year, now.month));
  }

  void goToPrevious() {
    state = state.copyWith(
      baseDate:
          state.type == FeedRankingType.weekly
              ? state.baseDate.subtract(Duration(days: 7))
              : DateTime(state.baseDate.year, state.baseDate.month - 1, state.baseDate.day),
    );
  }

  void goToNext() {
    state = state.copyWith(
      baseDate:
          state.type == FeedRankingType.weekly
              ? state.baseDate.add(Duration(days: 7))
              : DateTime(state.baseDate.year, state.baseDate.month + 1, state.baseDate.day),
    );
  }

  void setBaseDate(int year, int month) {
    state = state.copyWith(baseDate: DateTime(year, month));
  }
}

enum FeedRankingType { weekly, monthly }

@freezed
abstract class PopularRankingOption with _$PopularRankingOption {
  const factory PopularRankingOption({
    @Default(FeedRankingType.weekly) FeedRankingType type,
    required DateTime baseDate,
  }) = _PopularRankingOption;
}

extension PopularRankingOptionX on PopularRankingOption {
  bool get isNextAvailable {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (type) {
      FeedRankingType.weekly => baseDate.isBefore(today),
      FeedRankingType.monthly =>
        baseDate.year < today.year || (baseDate.year == today.year && baseDate.month < today.month),
    };
  }

  bool get isPreviousAvailable {
    // 출시일 25년 2월 22일
    final minimumDate = DateTime(2025, 02, 22);

    return switch (type) {
      FeedRankingType.weekly => baseDate.subtract(Duration(days: 7)).isAfter(minimumDate),
      FeedRankingType.monthly =>
        baseDate.year > minimumDate.year || (baseDate.year == minimumDate.year && baseDate.month > minimumDate.month),
    };
  }
}
