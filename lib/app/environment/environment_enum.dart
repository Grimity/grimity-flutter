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
    dev => dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    prod => dotenv.env['KAKAO_NATIVE_APP_KEY']!,
  };
}
