import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/album/create_album_usecase.dart';
import 'package:grimity/domain/usecase/album/delete_album_usecase.dart';
import 'package:grimity/domain/usecase/album/insert_feed_to_album_usecase.dart';
import 'package:grimity/domain/usecase/album/remove_feeds_album_usecase.dart';
import 'package:grimity/domain/usecase/album/update_album_order_usecase.dart';
import 'package:grimity/domain/usecase/album/update_album_usecase.dart';

final createAlbumUseCase = getIt<CreateAlbumUseCase>();
final updateAlbumOrderUseCase = getIt<UpdateAlbumOrderUseCase>();
final removeFeedsAlbumUseCase = getIt<RemoveFeedsAlbumUseCase>();
final insertFeedToAlbumUseCase = getIt<InsertFeedToAlbumUseCase>();
final updateAlbumUseCase = getIt<UpdateAlbumUseCase>();
final deleteAlbumUseCase = getIt<DeleteAlbumUseCase>();
