import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/presentation/home/widget/gallery_card.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryItems = ref.watch(galleryProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: galleryItems.length,
      itemBuilder: (context, index) {
        final item = galleryItems[index];
        return GalleryCard(item: item);
      },
    );
  }
}