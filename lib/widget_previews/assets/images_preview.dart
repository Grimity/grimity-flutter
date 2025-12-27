import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/gen/assets.gen.dart';
import 'package:grimity/widget_previews/preview_wrapper.dart';

const double _kPreviewSize = 96;

@Preview(
  name: 'Assets/images PNG Preview',
  size: Size(1200, 800),
  wrapper: previewWrapper,
)
Widget assetsImagesPreview() => const _AssetsImagesPreviewApp();

class _AssetsImagesPreviewApp extends StatelessWidget {
  const _AssetsImagesPreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const _AssetsImagesPreviewPage(),
    );
  }
}

class _AssetsImagesPreviewPage extends StatelessWidget {
  const _AssetsImagesPreviewPage();

  @override
  Widget build(BuildContext context) {
    final List<_ImageGroup> groups = _loadImageGroups();
    final int total = groups.fold<int>(
      0,
      (sum, group) => sum + group.paths.length,
    );

    return DefaultTabController(
      length: groups.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assets/images PNG Preview ($total)'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final group in groups) Tab(text: '${group.name} (${group.paths.length})'),
            ],
          ),
        ),
        body: _ImagesTabView(groups: groups),
      ),
    );
  }
}

class _ImagesTabView extends StatelessWidget {
  const _ImagesTabView({required this.groups});

  final List<_ImageGroup> groups;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        for (final group in groups)
          _ImagesGrid(
            groupName: group.name,
            paths: group.paths,
          ),
      ],
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  const _ImagesGrid({
    required this.groupName,
    required this.paths,
  });

  final String groupName;
  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    if (paths.isEmpty) {
      return Center(
        child: Text('No PNG assets found under assets/images/$groupName.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 160,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        final String path = paths[index];
        final String label = _labelFor(groupName, path);

        return _ImageTile(
          path: path,
          label: label,
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.path,
    required this.label,
  });

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall ?? const TextStyle(fontSize: 11);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  path,
                  width: _kPreviewSize,
                  height: _kPreviewSize,
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

class _ImageGroup {
  const _ImageGroup({
    required this.name,
    required this.paths,
  });

  final String name;
  final List<String> paths;
}

List<_ImageGroup> _loadImageGroups() {
  final groups = <_ImageGroup>[
    _ImageGroup(
      name: 'root',
      paths: Assets.images.values.map((e) => e.path).toList(),
    ),
    _ImageGroup(
      name: 'image',
      paths: Assets.images.image.values.map((e) => e.path).toList(),
    ),
    _ImageGroup(
      name: 'profile',
      paths: Assets.images.profile.values.map((e) => e.path).toList(),
    ),
    _ImageGroup(
      name: 'sign_up',
      paths: Assets.images.signUp.values.map((e) => e.path).toList(),
    ),
  ];

  for (final group in groups) {
    group.paths.sort();
  }

  return groups;
}

String _labelFor(String groupName, String path) {
  final prefix = groupName == 'root' ? 'assets/images/' : 'assets/images/$groupName/';
  return path.replaceFirst(prefix, '');
}
