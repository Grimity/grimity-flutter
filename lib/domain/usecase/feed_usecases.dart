import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/feed/create_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_latest_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_today_popular_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed/like_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/remove_saved_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/save_feed_usecase.dart';
import 'package:grimity/domain/usecase/feed/unlike_feed_usecase.dart';

final createFeedUseCase = getIt<CreateFeedUseCase>();
final getLatestFeedsUseCase = getIt<GetLatestFeedsUseCase>();
final getTodayPopularFeedsUseCase = getIt<GetTodayPopularFeedsUseCase>();
final likeFeedUseCase = getIt<LikeFeedUseCase>();
final unlikeFeedUseCase = getIt<UnlikeFeedUseCase>();
final saveFeedUseCase = getIt<SaveFeedUseCase>();
final removeSavedFeedUseCase = getIt<RemoveSavedFeedUseCase>();
