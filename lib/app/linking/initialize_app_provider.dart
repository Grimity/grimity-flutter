import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initialize_app_provider.g.dart';

/// 앱 초기화 여부를 확인하기 위한 Provider.
/// 딥 링크로 앱이 켜졌을 때 ColdStart/WramStart를 구분하기 위해 사용합니다.
@Riverpod(keepAlive: true)
class InitializeApp extends _$InitializeApp {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}