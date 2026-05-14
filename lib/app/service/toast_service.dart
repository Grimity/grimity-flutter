import 'package:gds/gds.dart';

class ToastService {
  ToastService._();

  static void show(String message, GdsToastType type) {
    assert(GdsToastHost.context != null);
    GdsToast.open(GdsToastHost.context!, type: type, message: message);
  }

  static void showSuccess(String message) {
    show(message, GdsToastType.positive);
  }

  static void showFailure(String message) {
    show(message, GdsToastType.nagative);
  }
}
