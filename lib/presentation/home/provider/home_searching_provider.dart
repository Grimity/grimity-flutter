import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/data/model/search/drawing_model.dart';

final drawingsProvider = StateNotifierProvider<DrawingsNotifier, List<DrawingModel>>((ref) {
  return DrawingsNotifier();
});

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier();
});

final galleryProvider = StateNotifierProvider<GalleryNotifier, List<GalleryItem>>((ref) {
  return GalleryNotifier();
});

class DrawingsNotifier extends StateNotifier<List<DrawingModel>> {
  DrawingsNotifier() : super([]) {
    _initializeDrawings();
  }

  void _initializeDrawings() {
    state = [
      DrawingModel(
        id: '1',
        title: '오늘 그림',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DrawingModel(
        id: '2',
        title: '그림 그려봤어요',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      DrawingModel(
        id: '3',
        title: '낙서 그림',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DrawingModel(
        id: '4',
        title: '그림 피드백 부탁드려요',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void toggleLike(String drawingId) {
    state = state.map((drawing) {
      if (drawing.id == drawingId) {
        return drawing.copyWith(
          isLiked: !drawing.isLiked,
          likes: drawing.isLiked ? drawing.likes - 1 : drawing.likes + 1,
        );
      }
      return drawing;
    }).toList();
  }
}

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super([]) {
    _loadPosts();
  }

  void _loadPosts() {
    // 샘플 데이터
    state = [
      Post(
        id: 1,
        title: '그림을 그렸는데요',
        content: '안녕하세요 어기는 마쥬? 그냥 어쨌어요 출네요',
        author: '닉네임',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
        viewCount: 113,
        commentCount: 3,
        type: PostType.text,
      ),
      Post(
        id: 2,
        title: '이거 그림을 어떻게그렸는지 모르겠어요',
        content: '안녕하세요 어기는 마쥬? 그냥 어쨌어요 출네요',
        author: '닉네임',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
        viewCount: 113,
        commentCount: 12,
        type: PostType.text,
      ),
      Post(
        id: 3,
        title: '그림 그리는거 진짜 어려운 것 같아요',
        content: '어떻게 그림 어떻게 그렇갔는지 모르겠네.. #오늘의감정',
        author: '닉네임',
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
        viewCount: 113,
        commentCount: 3,
        type: PostType.text,
      ),
    ];
  }

  void addPost(Post post) {
    state = [post, ...state];
  }

  void removePost(int postId) {
    state = state.where((post) => post.id != postId).toList();
  }
}

class GalleryNotifier extends StateNotifier<List<GalleryItem>> {
  GalleryNotifier() : super([]) {
    _loadGallery();
  }

  void _loadGallery() {
    // 샘플 갤러리 데이터
    state = [
      GalleryItem(
        id: 1,
        title: '그림그리는사람',
        imageUrl: 'https://picsum.photos/300/200?random=1',
        author: 'Grimify',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        viewCount: 15,
      ),
      GalleryItem(
        id: 2,
        title: '그림',
        imageUrl: 'https://picsum.photos/300/200?random=2',
        author: 'Grimify',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        viewCount: 15,
      ),
      GalleryItem(
        id: 3,
        title: '나가자!그림',
        imageUrl: 'https://picsum.photos/300/400?random=3',
        author: '닉네임',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        viewCount: 15,
      ),
      GalleryItem(
        id: 4,
        title: '겨울의그림',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        author: '닉네임',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        viewCount: 15,
      ),
    ];
  }

  void addGalleryItem(GalleryItem item) {
    state = [item, ...state];
  }

  void removeGalleryItem(int itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }
}

final selectedTabProvider = StateProvider<int>((ref) => 0);

final categoriesProvider = Provider<List<String>>((ref) {
  return ['탄지로', '귀멸의 칼날', '고양이', '동물', '블루아카이브', '귀칼', '만화', '미쿠', '백업', '배경'];
});

final selectedCategoryProvider = StateProvider<String>((ref) => '');

final searchQueryProvider = StateProvider<String>((ref) => '');

final allUsersProvider = Provider<List<Map<String, String>>>((ref) {
  return const [
    {'username': '체리마루', 'profilePic': 'https://example.com/profile1.png'},
    {'username': '그림쟁이', 'profilePic': 'https://example.com/profile2.png'},
    {'username': '아트러버', 'profilePic': 'https://example.com/profile3.png'},
  ];
});

final allFreePostsProvider = Provider<List<Map<String, String>>>((ref) {
  return const [
    {'title': 'flutter tips', 'id': 'p1'},
    {'title': 'riverpod guide', 'id': 'p2'},
    {'title': 'free talk', 'id': 'p3'},
  ];
});

final filteredUsersProvider = Provider<List<Map<String, String>>>((ref) {
  final allUsers = ref.watch(allUsersProvider);
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return allUsers;

  final q = query.toLowerCase();
  return allUsers
      .where((u) => (u['username'] ?? '').toLowerCase().contains(q))
      .toList();
});

final filteredFreePostsProvider = Provider<List<Map<String, String>>>((ref) {
  final allPosts = ref.watch(allFreePostsProvider);
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return allPosts;

  final q = query.toLowerCase();
  return allPosts
      .where((p) => (p['title'] ?? '').toLowerCase().contains(q))
      .toList();
});

final filteredDrawingsProvider = Provider<List<DrawingModel>>((ref) {
  final drawings = ref.watch(drawingsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  Iterable<DrawingModel> filtered = drawings;

  if (searchQuery.isNotEmpty) {
    final q = searchQuery.toLowerCase();
    filtered = filtered.where((d) =>
        d.title.toLowerCase().contains(q) || d.author.toLowerCase().contains(q));
  }

  if (selectedCategory.isNotEmpty) {
    final c = selectedCategory.toLowerCase();
    filtered = filtered.where((d) => d.title.toLowerCase().contains(c));
  }

  return filtered.toList();
});
