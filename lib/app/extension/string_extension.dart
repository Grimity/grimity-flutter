import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/app/util/validator_util.dart';

extension StringExtension on String {
  /// 리사이즈를 지원하는 이미지 크기(너비 기준) 목록.
  static const supportResizeWidths = <int>[300, 600, 1200];

  static final imageSizeSuffixRegExp = RegExp(r"(\d+)x(\d+).\w+");

  /// 지원되는 가장 가까운 너비를 기준으로 크기 조정용 새로운 이미지 URL을 반환합니다.
  String getResizeUrl(int width) {
    if (width <= 0 || Flavor.isDev) return this;

    try {
      // 지원되는 리사이즈 크기 중 요청된 너비보다 크거나 같은 가장 작은 크기를 찾습니다.
      int closest = supportResizeWidths.firstWhere(
        (size) => size >= width,
        orElse: () => -1,
      );

      // 지원되는 리사이즈 크기보다 큰 경우.
      if (closest == -1) return this;

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

  /// 문자열 형태의 URL에서 이미지 고유 크기(가로, 세로)를 추출하고 이를 반환합니다.
  Size? getImageSize() {
    final match = imageSizeSuffixRegExp.firstMatch(this);
    if (match == null) {
      return null;
    }

    final width = int.tryParse(match.group(1) ?? '');
    final height = int.tryParse(match.group(2) ?? '');

    if (width == null || width <= 0 || height == null || height <= 0) {
      assert(false, 'Failed to parse valid image size from URL: $this');
      return null;
    }

    return Size(width.toDouble(), height.toDouble());
  }

  String? getUrlCheckMessage() {
    if (!ValidatorUtil.isValidUrl(this)) {
      return '숫자, 영문(소문자), 언더바(_)만 입력 가능합니다.';
    }

    if (ValidatorUtil.isForbiddenUrl(this)) {
      return '사용할 수 없는 URL입니다.';
    }

    return null;
  }
}
