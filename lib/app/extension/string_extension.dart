import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:grimity/app/environment/environment_enum.dart';

extension StringExtension on String {
  /// 리사이즈를 지원하는 이미지 크기(너비 기준) 목록.
  static const supportResizeWidths = <int>[300, 600, 1200];

  /// 지원되는 가장 가까운 너비를 기준으로 크기 조정용 새로운 이미지 URL을 반환합니다.
  String getResizeUrl(int width) {
    if (width == 0 || width == double.infinity) {
      return this;
    }

    // 지원되는 리사이즈 크기 중 가장 가까운 크기.
    int closest = supportResizeWidths.reduce(
      (a, b) => (a - width).abs() < (b - width).abs() ? a : b,
    );

    final parsedUri = Uri.parse(this);
    final newImageUri = Uri.parse(Env.dev.imageUrl);
    final queryParameters = {"s": closest.toStringAsFixed(0)};

    try {
      return parsedUri
          .replace(
            host: newImageUri.host,
            queryParameters: queryParameters,
          )
          .toString();
    } catch (error) {
      FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
      return this;
    }
  }
}
