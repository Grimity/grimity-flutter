import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'image_item_source.freezed.dart';

@freezed
sealed class ImageSourceItem with _$ImageSourceItem {
  const factory ImageSourceItem.asset(AssetEntity asset) = AssetImageSource;

  const factory ImageSourceItem.remote(String url) = RemoteImageSource;
}
