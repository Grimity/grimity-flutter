import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/me_api.dart';
import 'package:grimity/data/model/user/my_profile_response.dart';
import 'package:grimity/domain/entity/user.dart';
import 'package:grimity/domain/repository/me_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MeRepository)
class MeRepositoryImpl extends MeRepository {
  final MeAPI _meAPI;

  MeRepositoryImpl(this._meAPI);

  @override
  Future<Result<User>> getMe() async {
    try {
      final MyProfileResponse response = await _meAPI.getMyProfile();
      return Result.success(response.toEntity());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
