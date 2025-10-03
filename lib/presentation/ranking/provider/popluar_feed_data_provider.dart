import 'package:grimity/app/extension/date_time_extension.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/mixin/feed_mixin.dart';
import 'package:grimity/presentation/ranking/provider/popular_feed_ranking_option_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popluar_feed_data_provider.g.dart';

@riverpod
class PopularFeedRankingData extends _$PopularFeedRankingData with FeedMixin<List<Feed>> {
  @override
  FutureOr<List<Feed>> build() async {
    final option = ref.watch(popularFeedRankingOptionProvider);

    final result = switch (option.type) {
      FeedRankingType.weekly => await getFeedRankingsUseCase.execute(
        GetFeedRankingsRequest(
          startDate: option.baseDate.oneWeekBeforeFormatted,
          endDate: option.baseDate.toYearMonthDay,
        ),
      ),
      FeedRankingType.monthly => await getFeedRankingsUseCase.execute(
        GetFeedRankingsRequest(month: option.baseDate.toYearMonth),
      ),
    };

    return result.fold(onSuccess: (feeds) => feeds, onFailure: (e) => []);
  }

  Future<void> toggleLike({required String feedId, required bool like}) => onToggleLike(
    feedId: feedId,
    like: like,
    optimisticBuilder: (prev) {
      return prev
          .map(
            (e) => e.id == feedId ? e.copyWith(likeCount: like ? e.likeCount! + 1 : e.likeCount! - 1, isLike: like) : e,
          )
          .toList();
    },
  );
}
