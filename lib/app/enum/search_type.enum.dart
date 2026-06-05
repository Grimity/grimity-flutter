import 'package:freezed_annotation/freezed_annotation.dart';

enum SearchType {
  @JsonValue('combined')
  combined('제목'),
  @JsonValue('name')
  name('글쓴이');

  final String displayName;
  const SearchType(this.displayName);
}
