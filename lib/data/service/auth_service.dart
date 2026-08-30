import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/enum/login_provider.enum.dart';
import 'package:grimity/app/util/device_info_util.dart';
import 'package:grimity/data/data_source/remote/oauth_api.dart';
import 'package:grimity/data/gen/clients/auth_api.dart';
import 'package:grimity/data/gen/models/auth_provider.dart' as generated;
import 'package:grimity/data/gen/models/grimity_app_device.dart' as generated;
import 'package:grimity/data/gen/models/login_request.dart' as generated;
import 'package:grimity/data/gen/models/register_request.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/domain/dto/auth_request_params.dart';
import 'package:grimity/domain/entity/token.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final RestClient _client;
  final OAuthAPI _oauthAPI;
  final AuthApi _refreshAuthApi;

  AuthService(this._client, this._oauthAPI, @Named('refreshAuthApi') this._refreshAuthApi);

  generated.AuthProvider _toGeneratedProvider(String provider) {
    switch (provider.toUpperCase()) {
      case 'GOOGLE':
        return generated.AuthProvider.google;
      case 'KAKAO':
        return generated.AuthProvider.kakao;
      case 'APPLE':
        return generated.AuthProvider.apple;
      default:
        throw ArgumentError.value(provider, 'provider', 'Unsupported login provider');
    }
  }

  Future<Result<Token>> login(LoginRequestParam request) async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final response = await _client.auth.authLogin(
        grimityAppModel: appModel,
        grimityAppDevice: generated.GrimityAppDevice.fromJson(appDevice),
        body: generated.LoginRequest(
          provider: _toGeneratedProvider(request.provider),
          providerAccessToken: request.providerAccessToken,
          deviceId: request.deviceId,
        ),
      );

      return Result.success(Token(accessToken: response.accessToken, refreshToken: response.refreshToken));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<String>> loginWithOAuth(LoginProvider provider) async {
    try {
      final String accessToken;

      switch (provider) {
        case LoginProvider.google:
          accessToken = await _oauthAPI.loginWithGoogle();
        case LoginProvider.kakao:
          accessToken = await _oauthAPI.loginWithKakao();
        case LoginProvider.apple:
          accessToken = await _oauthAPI.loginWithApple();
      }

      return Result.success(accessToken);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      await _client.auth.authLogout(
        grimityAppModel: appModel,
        grimityAppDevice: generated.GrimityAppDevice.fromJson(appDevice),
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(e as Exception);
    }
  }

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
          await _oauthAPI.logoutWithApple();
          break;
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e as Exception);
    }
  }

  Future<Result<Token>> refresh() async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final response = await _refreshAuthApi.authRefresh(
        grimityAppModel: appModel,
        grimityAppDevice: generated.GrimityAppDevice.fromJson(appDevice),
      );
      return Result.success(Token(accessToken: response.accessToken, refreshToken: response.refreshToken));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<Token>> register(RegisterRequestParam request) async {
    try {
      final appModel = await DeviceInfoUtil.getAppModel();
      final appDevice = await DeviceInfoUtil.getAppDevice();

      final response = await _client.auth.authRegister(
        grimityAppModel: appModel,
        grimityAppDevice: generated.GrimityAppDevice.fromJson(appDevice),
        body: generated.RegisterRequest(
          provider: _toGeneratedProvider(request.provider),
          providerAccessToken: request.providerAccessToken,
          deviceId: request.deviceId,
          name: request.name,
          url: request.url,
        ),
      );
      return Result.success(Token(accessToken: response.accessToken, refreshToken: response.refreshToken));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
