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
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      DrawingModel(
        id: '2',
        title: '그림 그려봤어요',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
      ),
      DrawingModel(
        id: '3',
        title: '낙서 그림',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      DrawingModel(
        id: '4',
        title: '그림 피드백 부탁드려요',
        author: '체리마루',
        likes: 24,
        views: 113,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
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

// 선택된 탭 상태
final selectedTabProvider = StateProvider<int>((ref) => 0);

// 카테고리 목록
final categoriesProvider = Provider<List<String>>((ref) {
  return ['한지로', '과정의 컬닝', '고양이', '통통', '볼루와이어', '귀엽', '한적', '미끄', '백업', '베껍'];
});

// 선택된 카테고리 상태
final selectedCategoryProvider = StateProvider<String>((ref) => '');

// 검색어 상태
final searchQueryProvider = StateProvider<String>((ref) => '');

// 필터링된 그림 목록
final filteredDrawingsProvider = Provider<List<DrawingModel>>((ref) {
  final drawings = ref.watch(drawingsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  var filtered = drawings;

  // 검색어로 필터링
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where((drawing) =>
    drawing.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        drawing.author.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  // 카테고리로 필터링 (실제로는 더 복잡한 로직이 필요)
  if (selectedCategory.isNotEmpty) {
    // 여기서는 예시로 단순히 전체 리스트를 반환
    // 실제로는 카테고리에 맞는 필터링 로직 구현
  }

  return filtered;
});
