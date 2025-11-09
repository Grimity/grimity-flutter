import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/image/image_upload.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_upload_provider.g.dart';

part 'feed_upload_provider.freezed.dart';

/// 피드 업로드 화면을 관리하는 프로바이더
@riverpod
class FeedUpload extends _$FeedUpload {
  @override
  FeedUploadState build() {
    return FeedUploadState();
  }

  void initializeForEdit(Feed feed) {
    state = state.copyWith(
      albumId: feed.album?.id ?? 'all',
      title: feed.title,
      content: feed.content ?? '',
      tags: feed.tags ?? [],
      images: feed.cards?.map((e) => ImageSourceItem.remote(e)).toList() ?? [],
      thumbnailImage: ImageSourceItem.remote(feed.thumbnail ?? ''),
      feedId: feed.id,
    );
  }

  /// 제목 업데이트
  void updateTitle(String title) {
    if (title.length > 32) {
      return;
    }
    state = state.copyWith(title: title);
  }

  /// 제목 업데이트
  void updateContent(String content) {
    if (content.length > 300) {
      return;
    }
    state = state.copyWith(content: content);
  }

  /// 이미지 업데이트
  void updateImages(List<ImageSourceItem> images) {
    state = state.copyWith(images: images);
  }

  /// 대표 이미지 업데이트
  void updateThumbnailImage(ImageSourceItem thumbnailImage) {
    state = state.copyWith(thumbnailImage: thumbnailImage);
  }

  /// 태그 업데이트
  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  /// 태그 추가
  void addTag(String tag) {
    if (tag.isEmpty) return;

    state = state.copyWith(tags: [...state.tags, tag]);
  }

  /// 태그 삭제
  String removeLastTag() {
    if (state.tags.isEmpty) return '';

    final lastTag = state.tags.last;
    final newTags = state.tags.sublist(0, state.tags.length - 1);
    state = state.copyWith(tags: newTags);
    return lastTag;
  }

  /// 선택된 앨범 업데이트
  void updateAlbumId(String albumId) {
    state = state.copyWith(albumId: albumId);
  }

  /// 선택된 이미지 삭제
  void removeImage(ImageSourceItem imageSource) {
    final newImages = state.images.where((image) => image != imageSource).toList();

    final isThumbnail = imageSource == state.thumbnailImage;
    final newThumbnail = isThumbnail ? (newImages.isNotEmpty ? newImages.first : null) : state.thumbnailImage;

    state = state.copyWith(images: newImages, thumbnailImage: newThumbnail);
  }

  void _setUploading(bool isUploading) {
    state = state.copyWith(uploading: isUploading);
  }

  /// 피드 업로드
  /// 성공 시 Feed, 실패 시 null
  Future<Feed?> feedUpload() async {
    if (state.uploading ||
        state.images.isEmpty ||
        state.title.isEmpty ||
        state.content.isEmpty ||
        state.thumbnailImage == null) {
      return null;
    }
    _setUploading(true);

    try {
      // 업로드 된 후 Feed 정보
      Feed? uploadedFeed;
      List<String> cards = [];
      final thumbnailIndex = state.images.indexOf(state.thumbnailImage ?? state.images.first);

      if (state.images.isNotEmpty) {
        final urlResult = await ImageUpload.uploadAssets(state.images, PresignedType.feed);
        cards = urlResult.map((e) => e.imageName).toList();
      }

      // 4. 피드 생성/수정 요청
      // 4.1 create
      if (state.feedId == null) {
        final thumbnail = cards[thumbnailIndex];
        final createFeedRequest = CreateFeedRequest(
          title: state.title,
          cards: cards,
          content: state.content,
          tags: state.tags,
          thumbnail: thumbnail,
          albumId: state.albumId == 'all' ? null : state.albumId,
        );

        final createFeedResult = await createFeedUseCase.execute(createFeedRequest);
        if (createFeedResult.isFailure) {
          ToastService.showError('피드 생성에 실패했습니다.');
          return null;
        }

        uploadedFeed = Feed(
          id: createFeedResult.data,
          title: state.title,
          cards: cards.map((imagePath) => AppConfig.buildImageUrl(imagePath)).toList(),
          content: state.content,
          tags: state.tags,
          thumbnail: AppConfig.buildImageUrl(thumbnail),
        );
      }
      // 4.2 update
      else {
        final remoteImages = state.images.whereType<RemoteImageSource>().map((e) => e.url).toList();
        // imageUrl 제거 처리 후 나머지 path 사용
        final remoteImageCards = remoteImages.map((e) => e.replaceFirst(AppConfig.imageUrl, '')).toList();
        cards = [...remoteImageCards, ...cards];
        final thumbnail = cards[thumbnailIndex];

        final updateFeedRequest = UpdateFeedUseCaseParam(
          id: state.feedId!,
          request: UpdateFeedRequest(
            title: state.title,
            cards: cards,
            content: state.content,
            tags: state.tags,
            thumbnail: thumbnail,
            albumId: state.albumId == 'all' ? null : state.albumId,
          ),
        );

        final updateFeedResult = await updateFeedUseCase.execute(updateFeedRequest);
        if (updateFeedResult.isFailure) {
          ToastService.showError('피드 수정에 실패했습니다.');
          return null;
        }

        // 업데이트의 경우 갱신
        ref.invalidate(feedDetailDataProvider(state.feedId!));

        uploadedFeed = Feed(
          id: state.feedId!,
          title: state.title,
          cards: cards.map((imagePath) => AppConfig.buildImageUrl(imagePath)).toList(),
          content: state.content,
          tags: state.tags,
          thumbnail: AppConfig.buildImageUrl(thumbnail),
        );
      }

      // Feed와 관련된 provider 갱신되도록 처리
      ref.invalidate(latestFeedDataProvider);
      ref.invalidate(profileDataProvider);
      ref.invalidate(profileFeedsDataProvider);

      // 업로드된 Feed 정보 반환
      return uploadedFeed;
    } finally {
      _setUploading(false);
    }
  }
}

/// 피드 업로드 화면 상태 클래스
@freezed
abstract class FeedUploadState with _$FeedUploadState {
  const factory FeedUploadState({
    @Default('') String title, // 제목
    @Default('') String content, //본문
    @Default([]) List<ImageSourceItem> images, // 이미지
    ImageSourceItem? thumbnailImage, // 썸네일 이미지
    @Default([]) List<String> tags, // 태그
    @Default('all') String albumId, // 선택된 앨범
    @Default(false) bool uploading,
    String? feedId,
  }) = _FeedUploadState;
}
