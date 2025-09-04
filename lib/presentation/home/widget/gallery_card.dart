import 'package:flutter/material.dart';
import '../../../domain/entity/user.dart';

class GalleryCard extends StatelessWidget {
  final User user;
  const GalleryCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? '(이름 없음)';
    final image = user.image ?? '';
    final url = user.url ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.black, backgroundImage: image.isNotEmpty ? NetworkImage(image) : null),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
              if (url.isNotEmpty) Text(url, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ])),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
              child: const Text('팔로우', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}
