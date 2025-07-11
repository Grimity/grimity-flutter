import 'package:dio/dio.dart';

/// 중복된 앨범 Exception
class AlbumNameConflictException implements Exception {
  final DioException error;

  AlbumNameConflictException(this.error);

  @override
  String toString() => 'AlbumNameConflictException: ${error.message}';
}
