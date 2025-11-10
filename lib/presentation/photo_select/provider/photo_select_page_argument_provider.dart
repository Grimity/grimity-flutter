import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/common/enum/upload_image_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_select_page_argument_provider.g.dart';

@Riverpod(dependencies: [])
UploadImageType photoSelectTypeArgument(Ref ref) {
  throw Exception('argument를 초기화 시켜 주어야 합니다');
}
