import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entity/feed.dart';

class DrawingCardWidget extends ConsumerWidget {
  final Feed feed;
  const DrawingCardWidget({Key? key, required this.feed}) : super(key: key);

  String _fullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    const base = 'https://image.grimity.com/'; // 실제 베이스로 교체
    return '$base$path';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = feed.title ?? '';
    final thumb = _fullImageUrl(feed.thumbnail);
    final likes = feed.likeCount ?? 0;
    final views = feed.viewCount ?? 0;
    final author = feed.author?.name ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0,2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: thumb.isEmpty
                ? Container(color: Colors.grey[200], child: Icon(Icons.image, size: 40, color: Colors.grey[400]))
                : Image.network(thumb, fit: BoxFit.cover, width: double.infinity),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green[700]), overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              if (author.isNotEmpty)
                Text(author, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 8),
              const Icon(Icons.favorite, size: 12, color: Colors.redAccent),
              const SizedBox(width: 2),
              Text('$likes', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 8),
              Icon(Icons.visibility, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 2),
              Text('$views', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ]),
          ]),
        ),
      ]),
    );
  }
}
