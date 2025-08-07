import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_author_data_provider.g.dart';

@riverpod
class PopularAuthorData extends _$PopularAuthorData {
  @override
  FutureOr<List<User>> build() async {
    final result = await getPopularUsersUseCase.execute();
    return result.fold(onSuccess: (users) => users.users, onFailure: (e) => []);
  }
}
