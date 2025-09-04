enum SearchBy { combined, name }

extension SearchByX on SearchBy {
  String get value {
    switch (this) {
      case SearchBy.combined:
        return 'combined';
      case SearchBy.name:
        return 'name';
    }
  }
}
