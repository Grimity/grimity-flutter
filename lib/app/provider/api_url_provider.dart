import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/di/api_url_provider.dart';

part 'api_url_provider.g.dart';

@riverpod
ApiUrlProvider apiUrl(Ref ref) {
  return getIt<ApiUrlProvider>();
}
