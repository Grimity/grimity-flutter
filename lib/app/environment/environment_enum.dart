import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Env {
  dev(type: 'DEV'),
  prod(type: 'PROD');

  final String type;

  const Env({required this.type});

  String get getString => switch (this) {
    dev => 'dev',
    prod => 'prod',
  };

  String get baseUrl => switch (this) {
    dev => dotenv.env['DEV_BASE_URL']!,
    prod => dotenv.env['BASE_URL']!,
  };

  String get apiUrl => switch (this) {
    dev => dotenv.env['DEV_API_URL']!,
    prod => dotenv.env['API_URL']!,
  };

  String get imageUrl => switch (this) {
    dev => dotenv.env['DEV_IMAGE_URL']!,
    prod => dotenv.env['IMAGE_URL']!,
  };

  String get dotFileName => switch (this) {
    dev => '.env',
    prod => '.env',
  };

  String get kakaoApiKey => switch (this) {
    dev => dotenv.env['DEV_KAKAO_NATIVE_APP_KEY']!,
    prod => dotenv.env['KAKAO_NATIVE_APP_KEY']!,
  };

  /// iOS의 경우 ClientID를 사용
  String? get googleSignInClientId => switch (this) {
    dev => Platform.isIOS ? dotenv.env['DEV_GOOGLE_SIGN_IN_CLIENT_ID']! : null,
    prod => Platform.isIOS ? dotenv.env['GOOGLE_SIGN_IN_CLIENT_ID']! : null,
  };
}
