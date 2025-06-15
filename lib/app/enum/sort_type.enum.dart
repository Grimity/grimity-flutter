import 'package:freezed_annotation/freezed_annotation.dart';

enum SortType {
  @JsonValue('latest')
  latest,
  @JsonValue('like')
  like,
  @JsonValue('oldest')
  oldest,
}
