import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/data/model/search/drawing_model.dart';

final drawingsProvider = StateNotifierProvider<DrawingsNotifier, List<DrawingModel>>((ref) {
  return DrawingsNotifier();
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
