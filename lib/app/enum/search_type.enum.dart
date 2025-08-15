import 'package:freezed_annotation/freezed_annotation.dart';

enum SearchType {
  @JsonValue('combined')
  combined('제목+내용'),
  @JsonValue('name')
  name('글쓴이');

  final String typeName;

  const SearchType(this.typeName);
}
