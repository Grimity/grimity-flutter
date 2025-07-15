import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/di/image_url_provider.dart';

part 'image_url_provider.g.dart';

@riverpod
ImageUrlProvider imageUrl(Ref ref) {
  return getIt<ImageUrlProvider>();
}
