import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/util/device_info_util.dart';
import 'package:grimity/data/data_source/remote/auth_api.dart';
import 'package:grimity/data/data_source/remote/oauth_api.dart';
import 'package:grimity/data/data_source/remote/refresh_token_api.dart';
import 'package:grimity/data/model/auth/login_response.dart';
import 'package:grimity/data/model/auth/refresh_response.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:grimity/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthAPI _authAPI;
  final OAuthAPI _oauthAPI;
  final RefreshTokenAPI _refreshTokenAPI;

  AuthRepositoryImpl(this._authAPI, this._oauthAPI, this._refreshTokenAPI);

  @override
  Future<Result<Token>> login(LoginRequestParam request) async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final LoginResponse response = await _authAPI.login(appModel, appDevice, request);

      return Result.success(response.toToken());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<String>> loginWithOAuth(LoginProvider provider) async {
    try {
      final String accessToken;

      switch (provider) {
        case LoginProvider.google:
          accessToken = await _oauthAPI.loginWithGoogle();
        case LoginProvider.kakao:
          accessToken = await _oauthAPI.loginWithKakao();
        case LoginProvider.apple:
          return Result.failure(Exception('Apple login is not implemented'));
      }

      return Result.success(accessToken);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      await _authAPI.logout(appModel, appDevice);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e as Exception);
    }
  }

  @override
  Future<Result<void>> logoutWithOAuth(LoginProvider provider) async {
    try {
      switch (provider) {
        case LoginProvider.google:
          await _oauthAPI.logoutWithGoogle();
          break;
        case LoginProvider.kakao:
          await _oauthAPI.logoutWithKakao();
          break;
        case LoginProvider.apple:
          return Result.failure(Exception('Apple logout is not implemented'));
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e as Exception);
    }
  }

  @override
  Future<Result<Token>> refresh() async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final RefreshResponse response = await _refreshTokenAPI.refresh(appModel, appDevice);
      return Result.success(response.toToken());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  @override
  Future<Result<Token>> register(RegisterRequestParam request) async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final LoginResponse response = await _authAPI.register(appModel, appDevice, request);
      return Result.success(response.toToken());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
