import 'package:grimity/app/base/result.dart';

abstract class UsersRepository {
  Future<Result<void>> nameCheck(String name);
}
