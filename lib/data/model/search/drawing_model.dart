class DrawingModel {
  final String id;
  final String title;
  final String author;
  final int likes;
  final int views;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isLiked;

  DrawingModel({
    required this.id,
    required this.title,
    required this.author,
    required this.likes,
    required this.views,
    this.imageUrl,
    required this.createdAt,
    this.isLiked = false,
  });

  DrawingModel copyWith({
    String? id,
    String? title,
    String? author,
    int? likes,
    int? views,
    String? imageUrl,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return DrawingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final int viewCount;
  final int commentCount;
  final String? imageUrl;
  final PostType type;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.viewCount,
    required this.commentCount,
    this.imageUrl,
    required this.type,
  });
}

enum PostType { text, image }

class GalleryItem {
  final int id;
  final String title;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final int viewCount;

  GalleryItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.viewCount,
  });
}