import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_data_provider.g.dart';

@riverpod
class ProfileData extends _$ProfileData {
  @override
  FutureOr<User?> build(String url) async {
    final result = await getUserProfileByUrlUseCase.execute(url);

    return result.fold(onSuccess: (profile) => profile, onFailure: (e) => null);
  }
}
