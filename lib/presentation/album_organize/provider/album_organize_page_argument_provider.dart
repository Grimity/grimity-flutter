import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_organize_page_argument_provider.g.dart';

@Riverpod(dependencies: [])
User albumOrganizeUserArgument(Ref ref) {
  throw Exception('argument를 초기화 시켜 주어야 합니다');
}
