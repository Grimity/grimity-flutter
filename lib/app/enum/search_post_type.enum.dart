enum SearchBy { combined, name }

extension SearchByX on SearchBy {
  String get value => switch (this) {
    SearchBy.combined => 'combined',
    SearchBy.name => 'name',
  };
}
