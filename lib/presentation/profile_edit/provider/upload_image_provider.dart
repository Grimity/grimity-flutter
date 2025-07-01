import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grimity/app/config/app_const.dart';
import 'package:grimity/app/enum/presigned.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/usecase/aws_usecases.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:grimity/presentation/profile_edit/provider/profile_edit_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_image_provider.g.dart';

enum UploadImageType {
  profile,
  background;

  String toJson() => name;

  static UploadImageType fromJson(String value) =>
      UploadImageType.values.firstWhere((e) => e.name == value);
}

@Riverpod(keepAlive: true)
class UploadImage extends _$UploadImage {
  @override
  UploadImageState build(UploadImageType type) {
    return UploadImageState(type: type);
  }

  Future<bool> pickImage(UploadImageType type) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return false;
    }

    state = state.copyWith(image: image, type: type);
    return true;
  }

  Future<void> setMemoryImage(MemoryImage image) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    final tempFile = File('$tempPath/crop_${DateTime.now().millisecondsSinceEpoch}.png');
    await tempFile.writeAsBytes(image.bytes);

    state = state.copyWith(image: XFile(tempFile.path, mimeType: 'image/png'));
  }

  Future<bool> updateImage() async {
    if (state.image == null) {
      return false;
    }

    setUploading(true);

    try {
      // Presigned URL 발급
      final presignedType = state.type == UploadImageType.profile ? PresignedType.profile : PresignedType.background;
      final urlRequest = GetPresignedUrlRequest(type: presignedType, ext: PresignedExt.webp);
      final urlResult = await getPresignedUrlUseCase.execute(urlRequest);

      if (urlResult.isFailure) {
        return false;
      }

      // AWS 이미지 업로드
      final uploadResult = await uploadImageUseCase.execute(
        UploadImageRequest(url: urlResult.data.url, filePath: state.image!.path),
      );

      if (uploadResult.isFailure) {
        return false;
      }

      // 프로필 이미지 업데이트
      if (state.type == UploadImageType.profile) {
        await updateProfileImageUseCase.execute(UpdateProfileImageRequestParam(imageName: urlResult.data.imageName));
      }
      // 배경 이미지 업데이트
      else {
        await updateBackgroundImageUseCase.execute(
          UpdateBackgroundImageRequestParam(imageName: urlResult.data.imageName),
        );
      }

      // 유저 정보 업데이트
      await ref.read(userAuthProvider.notifier).getUser();

      // profileEditProvider 업데이트
      if (state.type == UploadImageType.profile) {
        ref.read(profileEditProvider.notifier).updateImage(AppConst.imageUrl + urlResult.data.imageName);
        ToastService.show('프로필 이미지 업데이트가 완료되었습니다');
      } else {
        ref.read(profileEditProvider.notifier).updateBackgroundImage(AppConst.imageUrl + urlResult.data.imageName);
        ToastService.show('배경 이미지 업데이트가 완료되었습니다');
      }

      // 프로필 정보 업데이트
      ref.invalidate(profileDataProvider);
    } finally {
      setUploading(false);
    }

    return true;
  }

  Future<void> deleteImage(UploadImageType type) async {
    if (type == UploadImageType.profile) {
      await deleteProfileImageUseCase.execute();
      await ref.read(userAuthProvider.notifier).getUser();
      ref.read(profileEditProvider.notifier).updateImage(null);
    } else {
      await deleteBackgroundImageUseCase.execute();
      await ref.read(userAuthProvider.notifier).getUser();
      ref.read(profileEditProvider.notifier).updateBackgroundImage(null);
    }
  }

  void setUploading(bool isUploading) {
    state = state.copyWith(
      isUploading: isUploading
    );
  }
}

class UploadImageState {
  final XFile? image;
  final UploadImageType type;
  final bool isUploading;

  UploadImageState({this.image, required this.type, this.isUploading = false});

  UploadImageState copyWith({XFile? image, UploadImageType? type, bool? isUploading}) {
    return UploadImageState(
      image: image ?? this.image,
      type: type ?? this.type,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
