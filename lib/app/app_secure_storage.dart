import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 지정된 키의 문자열 값을 보안 저장소에서 조회·저장·삭제하는 래퍼.
class AppSecureStorage {
  const new _(this.key);

  final String key;

  static final accessToken = AppSecureStorage._('access_token');
  static final refreshToken = AppSecureStorage._('refresh_token');

  /// 보안 저장소 관련 플러그인.
  static final _plugin = const FlutterSecureStorage();

  /// iOS에서 기기 재시동 후 최초 잠금 해제부터 접근을 허용하고,
  /// iCloud 키체인 동기화를 활성화하는 옵션.
  static final _iOptions = const IOSOptions(
    accessibility: .first_unlock,
    synchronizable: true,
  );

  /// 저장된 값을 반환합니다. 저장된 값이 없으면 `null`을 반환합니다.
  Future<String?> get() {
    return _plugin.read(key: key, iOptions: _iOptions);
  }

  /// 주어진 값으로 저장합니다. 기존 값이 있으면 덮어씁니다.
  Future<void> set(String value) {
    return _plugin.write(key: key, value: value, iOptions: _iOptions);
  }

  /// 해당 키에 저장된 값을 삭제합니다.
  Future<void> delete() {
    return _plugin.delete(key: key, iOptions: _iOptions);
  }
}
