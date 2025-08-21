import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/data/model/search/drawing_model.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';

class DrawingCardWidget extends ConsumerWidget {
  final DrawingModel drawing;

  const DrawingCardWidget({Key? key, required this.drawing}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        drawing.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => DrawingHooks.useToggleLike(ref, drawing.id),
                      child: Icon(
                        drawing.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: drawing.isLiked ? Colors.red : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      drawing.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.favorite, size: 12, color: Colors.grey[400]),
                    SizedBox(width: 2),
                    Text(
                      '${drawing.likes}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.visibility, size: 12, color: Colors.grey[400]),
                    SizedBox(width: 2),
                    Text(
                      '${drawing.views}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
