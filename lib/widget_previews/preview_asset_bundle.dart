import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 위젯 프리뷰에서 앱 자산 경로를 패키지 경로로 변환하는 전용 번들.
class PreviewPackageAssetBundle extends PlatformAssetBundle {
  PreviewPackageAssetBundle({required this.packageName});

  final String packageName;

  static const String _kPackagesPrefix = 'packages';

  // 매니페스트는 원래 경로를 유지하고, 나머지 자산만 패키지 경로로 변환.
  @override
  Future<ByteData> load(String key) {
    if (_shouldBypass(key)) {
      return super.load(key);
    }
    return super.load(_toPackagePath(key));
  }

  @override
  Future<ImmutableBuffer> loadBuffer(String key) async {
    if (kIsWeb) {
      final ByteData bytes = await load(key);
      return ImmutableBuffer.fromUint8List(Uint8List.sublistView(bytes));
    }
    return ImmutableBuffer.fromAsset(
      key.startsWith(_kPackagesPrefix) ? key : _toPackagePath(key),
    );
  }

  bool _shouldBypass(String key) {
    return key == 'AssetManifest.bin' ||
        key == 'AssetManifest.json' ||
        key == 'AssetManifest.bin.json' ||
        key == 'FontManifest.json' ||
        key.startsWith(_kPackagesPrefix);
  }

  String _toPackagePath(String key) => '$_kPackagesPrefix/$packageName/$key';
}
