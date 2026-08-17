// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/popular_tag_response.dart';

part 'tags_api.g.dart';

@RestApi()
abstract class TagsApi {
  factory TagsApi(Dio dio, {String? baseUrl}) = _TagsApi;

  /// 인기 태그 조회(최대 30개)
  @GET('/tags/popular')
  Future<List<PopularTagResponse>> tagFindPopularTags();
}
