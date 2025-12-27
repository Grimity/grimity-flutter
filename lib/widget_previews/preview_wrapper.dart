import 'package:flutter/widgets.dart';
import 'package:grimity/widget_previews/preview_asset_bundle.dart';

const String _kPreviewPackageName = 'grimity';

// @Preview에서 사용하는 프리뷰용 AssetBundle 래퍼.
Widget previewWrapper(Widget child) {
  return DefaultAssetBundle(
    bundle: PreviewPackageAssetBundle(packageName: _kPreviewPackageName),
    child: child,
  );
}
