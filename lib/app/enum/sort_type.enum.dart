import 'package:freezed_annotation/freezed_annotation.dart';

enum SortType {
  @JsonValue('latest')
  latest('최신순'),
  @JsonValue('like')
  like('좋아요순'),
  @JsonValue('oldest')
  oldest('오래된순');

  final String typeName;

  const SortType(this.typeName);
}
