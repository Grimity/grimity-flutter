import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/album_edit/provider/album_edit_provider.dart';

class AlbumEditAppBar extends ConsumerWidget {
  const AlbumEditAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(albumEditProvider);
    final notifier = ref.read(albumEditProvider.notifier);

    return GdsTopNavigation.editor(
      title: '앨범 편집',
      label: context.isMobile ? '저장' : '저장하기',
      onTitle: () {},
      onBack: context.pop,
      onSave: () async {
        final saved = await notifier.saveChanges();
        if (context.mounted && saved) {
          context.pop();
        }
      },
      saveEnabled: notifier.canSave, 
      onBack: () {  
        context.pop();
      },
    );
  }
}
