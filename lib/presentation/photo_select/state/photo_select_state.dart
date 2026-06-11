import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/domain/entity/photo_album.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:photo_manager/photo_manager.dart';

part 'photo_select_state.freezed.dart';

@freezed
abstract class PhotoSelectState with _$PhotoSelectState {
  const factory PhotoSelectState({
    @Default(false) bool hasAccess, // 전체 접근 권한 || 선택 접근 권한
    @Default(false) bool isAuth, // 전체 접근 권한
    @Default([]) List<AssetEntity> photos, // 갤러리 이미지
    @Default([]) List<ImageSourceItem> selected, // 선택된 이미지
    ImageSourceItem? thumbnailImage, // 썸네일 이미지
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default([]) List<PhotoAlbum> albums, // 기기 앨범 목록
    AssetPathEntity? currentAlbum, // 현재 선택된 앨범(null = 최근 항목)
    @Default('최근 항목') String albumName, // 상단에 표출되는 앨범명
    @Default(false) bool isAlbumListExpanded, // 앨범 목록 펼침 여부
  }) = _PhotoSelectState;
}
