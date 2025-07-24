import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/feed/create_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_feed_detail_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_feed_rankings_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_latest_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed/like_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/remove_saved_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/save_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/unlike_feed_usecase.dart';

final createFeedUseCase = getIt<CreateFeedUseCase>();
final getLatestFeedsUseCase = getIt<GetLatestFeedsUseCase>();
final getFeedRankingsUseCase = getIt<GetFeedRankingsUseCase>();
final getFeedDetailUseCase = getIt<GetFeedDetailUseCase>();
final likeFeedUseCase = getIt<LikeFeedUseCase>();
final unlikeFeedUseCase = getIt<UnlikeFeedUseCase>();
final saveFeedUseCase = getIt<SaveFeedUseCase>();
final removeSavedFeedUseCase = getIt<RemoveSavedFeedUseCase>();
