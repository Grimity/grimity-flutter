import 'package:freezed_annotation/freezed_annotation.dart';

enum PostType {
  @JsonValue('NORMAL')
  normal('일반'),
  @JsonValue('QUESTION')
  question('질문'),
  @JsonValue('FEEDBACK')
  feedback('피드백'),
  @JsonValue('NOTICE')
  notice('공지사항'),
  @JsonValue('ALL')
  all('전체');

  final String typeName;

  const PostType(this.typeName);

  static String valueToName(String value) {
    switch (value) {
      case 'NORMAL':
        return '일반';
      case 'QUESTION':
        return '질문';
      case 'FEEDBACK':
        return '피드백';
      case 'NOTICE':
        return '공지사항';
      case 'ALL':
        return '전체';
    }
    return '';
  }
}
