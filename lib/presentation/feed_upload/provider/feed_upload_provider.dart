import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/dto/feeds_request_param.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/usecase/aws_usecases.dart';
import 'package:grimity/domain/usecase/feed_usecases.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/feed_detail/provider/feed_detail_data_provider.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_feeds_data_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
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
  /// 성공 시 FeedUrl, 실패 시 null
  Future<String?> feedUpload() async {
    if (state.uploading ||
        state.images.isEmpty ||
        state.title.isEmpty ||
        state.content.isEmpty ||
        state.thumbnailImage == null) {
      return null;
    }
    _setUploading(true);

    try {
      final imageAssets = state.images.whereType<AssetImageSource>().map((e) => e.asset).toList();
      final thumbnailIndex = state.images.indexOf(state.thumbnailImage ?? state.images.first);
      String feedUrl;
      List<String> cards = [];

      if (imageAssets.isNotEmpty) {
        // 1.Presigned URL 발급
        final presignedType = PresignedType.feed;
        final urlRequests = List.filled(
          imageAssets.length,
          GetPresignedUrlRequest(type: presignedType, ext: PresignedExt.webp),
        );

        final urlResult = await getPresignedUrlsUseCase.execute(urlRequests);
        if (urlResult.isFailure) {
          ToastService.showError('이미지 업로드 주소 생성에 실패했습니다.');
          return null;
        }

        // 2. AssetEntity -> XFile 변환 (임시 파일 생성)
        final xFileList = await _assetEntitiesToXFiles(imageAssets);
        if (xFileList.contains(null)) {
          ToastService.showError('이미지 파일을 읽을 수 없습니다.');
          return null;
        }

        // 3. AWS 이미지 업로드
        final uploadRequests = List.generate(
          urlResult.data.length,
          (index) => UploadImageRequest(url: urlResult.data[index].url, filePath: xFileList[index]!.path),
        );

        final uploadResult = await uploadImagesUseCase.execute(uploadRequests);
        if (uploadResult.isFailure) {
          ToastService.showError('문제가 발생하였습니다.');
          return null;
        }

        cards = urlResult.data.map((e) => e.imageName).toList();
      }

      // 4. 피드 생성/수정 요청
      // 4.1 create
      if (state.feedId == null) {
        final createFeedRequest = CreateFeedRequest(
          title: state.title,
          cards: cards,
          content: state.content,
          tags: state.tags,
          thumbnail: cards[thumbnailIndex],
          albumId: state.albumId == 'all' ? null : state.albumId,
        );

        final createFeedResult = await createFeedUseCase.execute(createFeedRequest);
        if (createFeedResult.isFailure) {
          ToastService.showError('피드 생성에 실패했습니다.');
          return null;
        }

        feedUrl = AppConfig.buildFeedUrl(createFeedResult.data);
      }
      // 4.2 update
      else {
        final remoteImages = state.images.whereType<RemoteImageSource>().map((e) => e.url).toList();
        final remoteImageCards = remoteImages.map((e) => 'feed/${e.split('/').last}').toList();
        cards = [...remoteImageCards, ...cards];

        final updateFeedRequest = UpdateFeedUseCaseParam(
          id: state.feedId!,
          request: UpdateFeedRequest(
            title: state.title,
            cards: cards,
            content: state.content,
            tags: state.tags,
            thumbnail: cards[thumbnailIndex],
            albumId: state.albumId == 'all' ? null : state.albumId,
          ),
        );

        final updateFeedResult = await updateFeedUseCase.execute(updateFeedRequest);
        if (updateFeedResult.isFailure) {
          ToastService.showError('피드 수정에 실패했습니다.');
          return null;
        }

        feedUrl = AppConfig.buildFeedUrl(state.feedId!);
        ref.invalidate(feedDetailDataProvider(state.feedId!));
      }

      // Feed와 관련된 provider 갱신되도록 처리
      ref.invalidate(latestFeedDataProvider);
      ref.invalidate(profileDataProvider);
      ref.invalidate(profileFeedsDataProvider);

      // FeedUrl 반환
      return feedUrl;
    } finally {
      _setUploading(false);
    }
  }

  /// AssetEntity List -> XFile List
  /// 파일 접근 불가(삭제 등)시 null 포함
  Future<List<XFile?>> _assetEntitiesToXFiles(List<AssetEntity> assets) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    return Future.wait(
      assets.map((asset) async {
        final file = await asset.file;
        if (file == null) return null;

        final id = asset.id.split('/').first;
        final tempFile = File('$tempPath/feed_${id}_${DateTime.now().millisecondsSinceEpoch}.png');

        try {
          await file.copy(tempFile.path);
          return XFile(tempFile.path, mimeType: 'image/png');
        } catch (e) {
          // 파일 복사 에러 $e
          return null;
        }
      }),
    );
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