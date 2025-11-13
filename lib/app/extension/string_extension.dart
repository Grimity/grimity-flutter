import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:grimity/app/environment/flavor.dart';

extension StringExtension on String {
  /// 리사이즈를 지원하는 이미지 크기(너비 기준) 목록.
  static const supportResizeWidths = <int>[300, 600, 1200];

  /// 지원되는 가장 가까운 너비를 기준으로 크기 조정용 새로운 이미지 URL을 반환합니다.
  String getResizeUrl(int width) {
    if (width <= 0) return this;

    try {
      // 지원되는 리사이즈 크기 중 요청된 너비보다 크거나 같은 가장 작은 크기를 찾습니다.
      int closest = supportResizeWidths.firstWhere(
        (size) => size >= width,
        orElse: () => supportResizeWidths.last,
      );

      final parsedUri = Uri.parse(this);
      final newImageUri = Uri.parse(Flavor.env.imageUrl);
      final queryParameters = {
        ...parsedUri.queryParameters,
        "s": closest.toString(),
      };

      return parsedUri
          .replace(
            host: newImageUri.host,
            queryParameters: queryParameters,
          )
          .toString();
    } catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return this;
    }
  }
}
