import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/widget_previews/preview_wrapper.dart';
import 'package:lottie/lottie.dart';

const double _kLottieSize = 120;

@Preview(
  name: 'Assets/lottie Preview',
  size: Size(1200, 800),
  wrapper: previewWrapper,
)
Widget assetsLottiePreview() => const _AssetsLottiePreviewApp();

class _AssetsLottiePreviewApp extends StatelessWidget {
  const _AssetsLottiePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const _AssetsLottiePreviewPage(),
    );
  }
}

class _AssetsLottiePreviewPage extends StatelessWidget {
  const _AssetsLottiePreviewPage();

  @override
  Widget build(BuildContext context) {
    final List<String> lotties = List<String>.of(Assets.lottie.values)..sort();
    return Scaffold(
      appBar: AppBar(
        title: Text('Assets/lottie Preview (${lotties.length})'),
      ),
      body: _LottieGrid(assets: lotties),
    );
  }
}

class _LottieGrid extends StatelessWidget {
  const _LottieGrid({required this.assets});

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return const Center(
        child: Text('No Lottie assets found under assets/lottie.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 180,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final String assetPath = assets[index];
        final String label = assetPath.replaceFirst('assets/lottie/', '');
        return _LottieTile(
          assetPath: assetPath,
          label: label,
        );
      },
    );
  }
}

class _LottieTile extends StatelessWidget {
  const _LottieTile({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = Theme.of(context).textTheme.labelSmall ?? const TextStyle(fontSize: 11);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Lottie.asset(
                  assetPath,
                  width: _kLottieSize,
                  height: _kLottieSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: labelStyle,
            ),
          ],
        ),
      ),
    );
  }
}
