import 'package:grimity/domain/entity/post.dart';
import 'package:grimity/domain/usecase/post_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_notice_data_provider.g.dart';

@riverpod
class BoardNoticeData extends _$BoardNoticeData {
  @override
  FutureOr<List<Post>> build() async {
    final result = await getNoticesUseCase.execute();

    return result.fold(onSuccess: (posts) => posts, onFailure: (e) => []);
  }
}
