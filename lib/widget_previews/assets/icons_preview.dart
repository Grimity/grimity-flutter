import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/widget_previews/preview_wrapper.dart';

const double _kIconSize = 32;

@Preview(
  name: 'Assets/icons SVG Preview',
  size: Size(1200, 800),
  wrapper: previewWrapper,
)
Widget assetsIconsPreview() => const _AssetsIconsPreviewApp();

class _AssetsIconsPreviewApp extends StatelessWidget {
  const _AssetsIconsPreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const _AssetsIconsPreviewPage(),
    );
  }
}

class _AssetsIconsPreviewPage extends StatelessWidget {
  const _AssetsIconsPreviewPage();

  @override
  Widget build(BuildContext context) {
    final List<_IconGroup> groups = _loadSvgIconGroups();
    final int total = groups.fold<int>(0, (int sum, _IconGroup group) => sum + group.assets.length);
    return DefaultTabController(
      length: groups.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assets/icons SVG Preview ($total)'),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Tab>[
              for (final _IconGroup group in groups) Tab(text: '${group.name} (${group.assets.length})'),
            ],
          ),
        ),
        body: _IconsTabView(groups: groups),
      ),
    );
  }
}

class _IconsTabView extends StatelessWidget {
  const _IconsTabView({required this.groups});

  final List<_IconGroup> groups;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        for (final _IconGroup group in groups)
          _IconsGrid(
            groupName: group.name,
            assets: group.assets,
          ),
      ],
    );
  }
}

class _IconsGrid extends StatelessWidget {
  const _IconsGrid({
    required this.groupName,
    required this.assets,
  });

  final String groupName;
  final List<SvgGenImage> assets;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return Center(
        child: Text('No SVG assets found under assets/icons/$groupName.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisExtent: 120,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final SvgGenImage asset = assets[index];
        final String label = asset.path.replaceFirst('assets/icons/$groupName/', '');
        return _IconTile(
          asset: asset,
          label: label,
        );
      },
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.asset,
    required this.label,
  });

  final SvgGenImage asset;
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
                child: asset.svg(
                  width: _kIconSize,
                  height: _kIconSize,
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

class _IconGroup {
  const _IconGroup({
    required this.name,
    required this.assets,
  });

  final String name;
  final List<SvgGenImage> assets;
}

List<_IconGroup> _loadSvgIconGroups() {
  final List<_IconGroup> groups = <_IconGroup>[
    _IconGroup(name: 'icon', assets: List<SvgGenImage>.of(Assets.icons.icon.values)),
    _IconGroup(name: 'brand', assets: List<SvgGenImage>.of(Assets.icons.brand.values)),
    _IconGroup(name: 'editor', assets: List<SvgGenImage>.of(Assets.icons.editor.values)),
    _IconGroup(name: 'illust', assets: List<SvgGenImage>.of(Assets.icons.illust.values)),
    _IconGroup(name: 'ranking', assets: List<SvgGenImage>.of(Assets.icons.ranking.values)),
  ];
  for (final _IconGroup group in groups) {
    group.assets.sort((SvgGenImage a, SvgGenImage b) => a.path.compareTo(b.path));
  }
  return groups;
}
