enum SearchType {
  combined('제목+내용'),
  question('글쓴이');

  final String typeName;

  const SearchType(this.typeName);
}
