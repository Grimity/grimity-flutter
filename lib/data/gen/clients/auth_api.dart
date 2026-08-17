// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/grimity_app_device.dart';
import '../models/jwt_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  /// 로그인.
  ///
  /// [grimityAppModel] - 앱에서만 사용되는 속성입니다.
  ///
  /// [grimityAppDevice] - 앱에서만 사용되는 속성입니다.
  @POST('/auth/login')
  Future<LoginResponse> authLogin({
    @Body() required LoginRequest body,
    @Header('grimity-app-model') String? grimityAppModel,
    @Header('grimity-app-device') GrimityAppDevice? grimityAppDevice,
  });

  /// 회원가입.
  ///
  /// [grimityAppModel] - 앱에서만 사용되는 속성입니다.
  ///
  /// [grimityAppDevice] - 앱에서만 사용되는 속성입니다.
  @POST('/auth/register')
  Future<LoginResponse> authRegister({
    @Body() required RegisterRequest body,
    @Header('grimity-app-model') String? grimityAppModel,
    @Header('grimity-app-device') GrimityAppDevice? grimityAppDevice,
  });

  /// 토큰 재발급 - refT를 담아야함.
  ///
  /// [grimityAppModel] - 앱에서만 사용되는 속성입니다.
  ///
  /// [grimityAppDevice] - 앱에서만 사용되는 속성입니다.
  @GET('/auth/refresh')
  Future<JwtResponse> authRefresh({
    @Header('grimity-app-model') String? grimityAppModel,
    @Header('grimity-app-device') GrimityAppDevice? grimityAppDevice,
  });

  /// 로그아웃 - refT를 담아야함.
  ///
  /// [grimityAppModel] - 앱에서만 사용되는 속성입니다.
  ///
  /// [grimityAppDevice] - 앱에서만 사용되는 속성입니다.
  @POST('/auth/logout')
  Future<void> authLogout({
    @Header('grimity-app-model') String? grimityAppModel,
    @Header('grimity-app-device') GrimityAppDevice? grimityAppDevice,
  });
}
