class SearchUsersParam {
  final String keyword;   // 필수 (2~20자)
  final String? cursor;   // 없으면 처음부터
  final int size;         // 페이지 크기

  const SearchUsersParam({
    required this.keyword,
    this.cursor,
    this.size = 20,
  });
}