import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/feed/get_latest_feeds_usecase.dart';
import 'package:grimity/domain/usecase/feed/get_today_popular_feeds_usecase.dart';

final getLatestFeedsUseCase = getIt<GetLatestFeedsUseCase>();
final getTodayPopularFeedsUseCase = getIt<GetTodayPopularFeedsUseCase>();
