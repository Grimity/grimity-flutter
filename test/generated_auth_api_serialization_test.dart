import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/data/gen/clients/auth_api.dart';
import 'package:grimity/data/gen/models/auth_provider.dart';
import 'package:grimity/data/gen/models/login_request.dart';

void main() {
  test('생성된 인증 API가 Freezed 요청을 JSON Map으로 전송한다', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'))..httpClientAdapter = adapter;
    final api = AuthApi(dio);

    await api.authLogin(
      body: const LoginRequest(
        provider: AuthProvider.google,
        providerAccessToken: 'oauth-token',
        deviceId: 'device-id',
      ),
    );

    expect(adapter.requestData, isA<Map<String, dynamic>>());
    expect(adapter.requestData, {
      'provider': 'GOOGLE',
      'providerAccessToken': 'oauth-token',
      'deviceId': 'device-id',
    });
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  Object? requestData;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestData = options.data;

    return ResponseBody.fromString(
      '{"accessToken":"access-token","refreshToken":"refresh-token","id":"user-id"}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
