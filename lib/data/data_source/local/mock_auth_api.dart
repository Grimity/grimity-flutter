import 'package:grimity/data/data_source/remote/auth_api.dart';
import 'package:grimity/data/model/auth/login_response.dart';
import 'package:grimity/domain/usecase/auth/login_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@dev
@Injectable(as: AuthAPI)
class MockAuthAPI extends Mock implements AuthAPI {
  @override
  Future<LoginResponse> login(LoginRequestParam request) async {
    return LoginResponse(id: 'id', accessToken: 'accessToken', refreshToken: 'refreshToken');
  }
}
