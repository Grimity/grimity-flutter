import 'package:fluttertoast/fluttertoast.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/presentation/common/widget/grimity_toast.dart';

class ToastService {
  ToastService._();

  static void show(String message, {bool showImmediately = false}) {
    _GrimityToast.instance.showToast(message, showImmediately: showImmediately);
  }

  static void showError(String message, {bool showImmediately = false}) {
    _GrimityToast.instance.showToast(message, type: GrimityToastType.error, showImmediately: showImmediately);
  }

  static void remove() {
    _GrimityToast.instance.remove();
  }

  static void removeQueued() {
    _GrimityToast.instance.removeQueued();
  }
}

class _GrimityToast {
  // Singleton
  static final _GrimityToast _instance = _GrimityToast._();
  static _GrimityToast get instance => _instance;

  _GrimityToast._() {
    _fToast = FToast();
    _initToast();
  }

  late FToast _fToast;
  bool _isInitialized = false;

  void _initToast() {
    if (rootNavigatorKey.currentContext != null) {
      _fToast.init(rootNavigatorKey.currentContext!);
      _isInitialized = true;
    }
  }

  void showToast(String message, {GrimityToastType type = GrimityToastType.verbose, bool showImmediately = false}) {
    // 토스트 인스턴스 초기화
    if (rootNavigatorKey.currentContext != null && !_isInitialized) {
      _initToast();
    }

    // 현재 토스트 표시중인 토스트가 있는 경우 삭제
    if (showImmediately) {
      _fToast.removeQueuedCustomToasts();
    }

    _fToast.showToast(
      child: GrimityToast(message: message, type: type),
      gravity: ToastGravity.TOP,
      fadeDuration: const Duration(milliseconds: 0),
      toastDuration: const Duration(milliseconds: 1500),
    );
  }

  void remove() {
    _fToast.removeCustomToast();
  }

  void removeQueued() {
    _fToast.removeQueuedCustomToasts();
  }
}
