import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/enum/post_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/delta_util.dart';
import 'package:grimity/domain/dto/image_request_params.dart';
import 'package:grimity/domain/dto/post_comments_request_params.dart';
import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/image_usecases.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:grimity/presentation/board/tabs/provider/board_post_data_provider.dart';
import 'package:grimity/presentation/common/model/image_item_source.dart';
import 'package:grimity/presentation/home/provider/home_data_provider.dart';
import 'package:grimity/presentation/post_detail/provider/post_detail_data_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_posts_data_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_upload_provider.freezed.dart';

part 'post_upload_provider.g.dart';

/// 피드 업로드 화면을 관리하는 프로바이더
@riverpod
class PostUpload extends _$PostUpload {
  @override
  PostUploadState build() => PostUploadState();

  void initializeForEdit(Post post) {
    state = state.copyWith(
      title: post.title,
      contentDeltaOps: DeltaUtil.htmlToOps(post.content),
      type: PostType.fromString(post.type ?? ''),
      postId: post.id,
    );
  }

  /// 제목 업데이트
  void updateTitle(String title) {
    if (title.length > 32) {
      return;
    }
    state = state.copyWith(title: title);
  }

  /// 내용 DeltaOps 업데이트
  /// Delta -> DeltaOps(Json)
  void replaceContentDelta(Delta contentDelta) {
    state = state.copyWith(contentDeltaOps: contentDelta.toJson());
  }

  /// type 업데이트
  void updateType(PostType type) {
    state = state.copyWith(type: type);
  }

  /// imageEdit 업데이트
  void updateImageEdit(bool imageEdit) {
    state = state.copyWith(imageEdit: imageEdit, selectedImageUrls: []);
  }

  /// selectedImageUrl toggle
  void toggleSelectedImageUrl(String imageUrl) {
    final selectedImageUrls = state.selectedImageUrls;
    final selected = selectedImageUrls.contains(imageUrl);

    state = state.copyWith(
      selectedImageUrls:
          selected ? selectedImageUrls.where((e) => e != imageUrl).toList() : [...selectedImageUrls, imageUrl],
    );
  }

  /// 선택된 이미지들 삭제
  void deleteSelectedImage(QuillController controller) {
    final targets = state.selectedImageUrls;
    if (targets.isEmpty) return;

    final delta = controller.document.toDelta();
    final toDeleteOffsets = <int>[];
    int offset = 0;

    for (final op in delta.toList()) {
      final data = op.data;

      if (data is String) {
        offset += data.length;
        continue;
      }

      if (data is Map && data.containsKey('image')) {
        final src = data['image']?.toString() ?? '';
        if (targets.contains(src)) {
          toDeleteOffsets.add(offset); // 이 위치의 임베드 삭제 대상
        }
        offset += 1;
        continue;
      }

      offset += 1;
    }

    if (toDeleteOffsets.isEmpty) return;

    // 뒤에서 앞으로 지우기 (오프셋 붕괴 방지)
    for (final start in toDeleteOffsets.reversed) {
      // 1) 임베드 삭제
      controller.replaceText(start, 1, '', TextSelection.collapsed(offset: start));

      // 2) 임베드 뒤에 따라오는 개행이 있으면 같이 삭제
      final plain = controller.document.toPlainText();
      if (start < plain.length && plain[start] == '\n') {
        controller.replaceText(start, 1, '', TextSelection.collapsed(offset: start));
      }
    }

    // 3) 상태 갱신 (에디터 화면과 provider 상태 동기화)
    state = state.copyWith(
      contentDeltaOps: controller.document.toDelta().toJson(),
      selectedImageUrls: [],
      imageEdit: false,
    );
  }

  void _setUploading(bool isUploading) {
    state = state.copyWith(uploading: isUploading);
  }

  /// 업로드할 이미지 업데이트
  void updateImages(List<ImageSourceItem> images) {
    final imageAssets = images.whereType<AssetImageSource>().map((e) => e.asset).toList();

    if (imageAssets.isEmpty) {
      return;
    }

    state = state.copyWith(images: imageAssets);
  }

  /// 이미지 추가
  void insertImage({required QuillController controller}) async {
    if (state.images.isEmpty) return;

    /// 1. 파일 변환(AssetEntity -> XFile)
    final xFileList = await _assetEntitiesToXFiles(state.images);
    if (xFileList.contains(null)) {
      ToastService.showError('이미지 파일을 읽을 수 없습니다.');
      return;
    }

    /// 2. 문서에 '로컬 경로'로 임베드 + Pending 생성 후 상태 업데이트
    final pending = _insertLocalImages(controller: controller, xFileList: xFileList);
    state = state.copyWith(pendingImages: [...state.pendingImages, ...pending]);

    /// 3. 업로드 개별 처리
    await _uploadPendingImages(controller: controller, targets: pending);

    /// 4. 문서 Delta 동기화
    state = state.copyWith(contentDeltaOps: controller.document.toDelta().toJson());
  }

  List<PendingUploadImage> _insertLocalImages({required QuillController controller, required List<XFile?> xFileList}) {
    var insertOffset = controller.selection.baseOffset;
    final pendingImages = <PendingUploadImage>[];

    for (final file in xFileList) {
      final localPath = file!.path;
      // 이미지 삽입
      controller.replaceText(
        insertOffset,
        0,
        BlockEmbed.image(localPath),
        TextSelection.collapsed(offset: insertOffset + 1),
      );
      insertOffset += 1;

      // 개행 삽입
      controller.replaceText(insertOffset, 0, '\n', TextSelection.collapsed(offset: insertOffset + 1));
      insertOffset += 1;
      pendingImages.add(PendingUploadImage(localPath: localPath, file: file));
    }

    return pendingImages;
  }

  Future<void> _uploadPendingImages({required QuillController controller, List<PendingUploadImage>? targets}) async {
    final pendingList = (targets ?? state.pendingImages).where((p) => p.remoteUrl == null).toList();

    for (final item in pendingList) {
      _updatePending(item.localPath, status: UploadStatus.uploading);

      try {
        // 1.Presigned URL 발급
        final urlResult = await getImageUploadUrlUseCase.execute(
          GetImageUploadUrlRequest(type: PresignedType.post, ext: PresignedExt.webp),
        );
        if (urlResult.isFailure) {
          _updatePending(item.localPath, status: UploadStatus.failed);
          ToastService.showError('이미지 업로드 주소 생성에 실패했습니다.');
          continue;
        }

        // 2. AWS 이미지 업로드
        final uploadResult = await uploadImageUseCase.execute(
          UploadImageRequest(url: urlResult.data.uploadUrl, filePath: item.localPath),
        );

        if (uploadResult.isFailure) {
          _updatePending(item.localPath, status: UploadStatus.failed);
          ToastService.showError('문제가 발생하였습니다.');
          continue;
        }

        final imageUrl = urlResult.data.imageUrl;
        _updatePending(item.localPath, status: UploadStatus.success, imageUrl: imageUrl);
        _replaceImageSource(controller, fromLocalPath: item.localPath, toImageUrl: imageUrl);
      } catch (e) {
        _updatePending(item.localPath, status: UploadStatus.failed);
      }
    }

    // 업로드/치환 이후 문서 동기화
    state = state.copyWith(contentDeltaOps: controller.document.toDelta().toJson());
  }

  void _updatePending(String localPath, {UploadStatus? status, String? imageUrl}) {
    final list = [...state.pendingImages];
    final idx = list.indexWhere((e) => e.localPath == localPath);
    if (idx == -1) return;

    list[idx] = list[idx].copyWith(status: status ?? list[idx].status, remoteUrl: imageUrl ?? list[idx].remoteUrl);
    state = state.copyWith(pendingImages: list);
  }

  void _replaceImageSource(QuillController controller, {required String fromLocalPath, required String toImageUrl}) {
    final delta = controller.document.toDelta();
    int offset = 0;

    for (final op in delta.toList()) {
      final data = op.data;
      if (data is String) {
        offset += data.length;
        continue;
      }
      if (data is Map && data.containsKey('image')) {
        final src = data['image']?.toString() ?? '';
        if (src == fromLocalPath) {
          controller.replaceText(offset, 1, BlockEmbed.image(toImageUrl), TextSelection.collapsed(offset: offset + 1));
          return;
        }
        offset += 1;
        continue;
      }
      offset += 1;
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
        final tempFile = File('$tempPath/post_${id}_${DateTime.now().millisecondsSinceEpoch}.png');

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

  /// 로컬 이미지가 포함되어 있는지 여부
  bool _hasLocalImages(Delta delta) {
    for (final op in delta.toList()) {
      final data = op.data;
      if (data is Map && data.containsKey('image')) {
        final src = data['image']?.toString() ?? '';
        if (!src.startsWith('http')) return true;
      }
    }
    return false;
  }

  /// 게시글 업로드
  /// 성공 시 PostUrl, 실패 시 null
  Future<String?> postUpload(QuillController controller) async {
    if (!state.canUpload) {
      return null;
    }

    _setUploading(true);

    /// 업로드에 실패한 이미지가 있을때 재시도
    await _uploadPendingImages(controller: controller);

    if (_hasLocalImages(state.contentData)) {
      ToastService.showError('이미지가 업로드되지 않았습니다.');
      _setUploading(false);
      return null;
    }

    try {
      String postUrl;

      // create
      if (state.postId == null) {
        final createPostRequest = CreatePostRequest(
          title: state.title,
          content: DeltaUtil.deltaToHtml(state.contentData),
          type: state.type,
        );

        final createPostResult = await createPostUseCase.execute(createPostRequest);
        if (createPostResult.isFailure) {
          ToastService.showError('게시글 생성에 실패했습니다.');
          return null;
        }

        postUrl = AppConfig.buildPostUrl(createPostResult.data);
      }
      // update
      else {
        UpdatePostWithIdRequestParam request = UpdatePostWithIdRequestParam(
          id: state.postId!,
          param: CreatePostRequest(
            title: state.title,
            content: DeltaUtil.deltaToHtml(state.contentData),
            type: state.type,
          ),
        );

        final createPostResult = await updatePostUseCase.execute(request);
        if (createPostResult.isFailure) {
          ToastService.showError('게시글 수정에 실패했습니다.');
          return null;
        }

        postUrl = AppConfig.buildPostUrl(state.postId!);
        ref.invalidate(postDetailDataProvider(state.postId!));
      }

      // Post와 관련된 provider 갱신되도록 처리
      ref.invalidate(latestPostDataProvider);
      ref.invalidate(boardPostDataProvider);
      ref.invalidate(profilePostsDataProvider);

      // PostUrl 반환
      return postUrl;
    } finally {
      _setUploading(false);
    }
  }
}

@freezed
abstract class PostUploadState with _$PostUploadState {
  factory PostUploadState({
    @Default('') String title, // 제목
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> contentDeltaOps,
    @Default(PostType.normal) PostType type, //일반, 질문, 피드백
    @Default([]) List<AssetEntity> images, // 업로드 할 이미지
    @Default(false) bool imageEdit, // 이미지 수정 상태
    @Default([]) List<String> selectedImageUrls, // 삭제 선택된 이미지
    @Default(<PendingUploadImage>[]) List<PendingUploadImage> pendingImages, // 이미지 전송 상태
    @Default(false) bool uploading, // 업로드 상태
    String? postId,
  }) = _PostUploadState;

  const PostUploadState._();

  Delta get contentData => Delta.fromJson(contentDeltaOps);
}

extension PostUploadStateX on PostUploadState {
  bool get hasContent => DeltaUtil.hasMeaningfulDeltaContent(contentData);

  bool get canUpload => !uploading && title.trim().isNotEmpty && hasContent;
}

enum UploadStatus { pending, uploading, success, failed }

class PendingUploadImage {
  final String localPath;
  final XFile file;
  final String? remoteUrl; // 업로드 성공시 채움
  final UploadStatus status;

  PendingUploadImage({required this.localPath, required this.file, this.remoteUrl, this.status = UploadStatus.pending});

  PendingUploadImage copyWith({String? localPath, XFile? file, String? remoteUrl, UploadStatus? status}) {
    return PendingUploadImage(
      localPath: localPath ?? this.localPath,
      file: file ?? this.file,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      status: status ?? this.status,
    );
  }
}
