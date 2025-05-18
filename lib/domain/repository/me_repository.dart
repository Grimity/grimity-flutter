import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/entity/user.dart';

abstract class MeRepository {
  Future<Result<User>> getMe();
}
