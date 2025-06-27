mixin PaginationMixin {
  int _currentPage = 1;
  int _size = 10;

  int get currentPage => _currentPage;

  int get size => _size;

  void setPagination({required int page, int? size}) {
    _currentPage = page;
    if (size != null) _size = size;
  }

  void resetPagination() {
    _currentPage = 1;
  }
}
