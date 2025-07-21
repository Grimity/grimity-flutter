import 'package:grimity/app/base/result.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class PhotoRepository {
  Future<Result<List<AssetEntity>>> fetchPhotos(int page);
}
