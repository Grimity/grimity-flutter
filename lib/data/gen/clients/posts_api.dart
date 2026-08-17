// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_post_request.dart';
import '../models/id_response.dart';
import '../models/post_base_response.dart';
import '../models/post_detail_response.dart';
import '../models/post_search_by.dart';
import '../models/post_type_filter.dart';
import '../models/post_with_author_response.dart';
import '../models/posts_response.dart';

part 'posts_api.g.dart';

@RestApi()
abstract class PostsApi {
  factory PostsApi(Dio dio, {String? baseUrl}) = _PostsApi;

  /// 게시글 생성
  @POST('/posts')
  Future<IdResponse> postCreate({
    @Body() required CreatePostRequest body,
  });

  /// 게시글 조회
  @GET('/posts')
  Future<PostsResponse> postGetPosts({
    @Query('type') required PostTypeFilter type,
    @Query('page') num? page = 1,
    @Query('size') num? size = 10,
  });

  /// 공지사항 조회
  @GET('/posts/notices')
  Future<List<PostWithAuthorResponse>> postGetNotices();

  /// 게시글 검색.
  ///
  /// [type] - 생략 시 ALL.
  @GET('/posts/search')
  Future<PostsResponse> postSearchPosts({
    @Query('keyword') required String keyword,
    @Query('searchBy') required PostSearchBy searchBy,
    @Query('type') PostTypeFilter? type,
    @Query('page') num? page = 1,
    @Query('size') num? size = 10,
  });

  /// 게시글 상세 조회 - Optional Guard
  @GET('/posts/{id}')
  Future<PostDetailResponse> postGetPost({
    @Path('id') required String id,
  });

  /// 게시글 수정
  @PUT('/posts/{id}')
  Future<void> postUpdate({
    @Path('id') required String id,
    @Body() required CreatePostRequest body,
  });

  /// 게시글 삭제
  @DELETE('/posts/{id}')
  Future<void> postDelete({
    @Path('id') required String id,
  });

  /// 게시글 메타데이터 조회
  @GET('/posts/{id}/meta')
  Future<PostBaseResponse> postGetMeta({
    @Path('id') required String id,
  });

  /// 게시글 좋아요
  @PUT('/posts/{id}/like')
  Future<void> postLike({
    @Path('id') required String id,
  });

  /// 게시글 좋아요 취소
  @DELETE('/posts/{id}/like')
  Future<void> postUnlike({
    @Path('id') required String id,
  });

  /// 게시글 저장
  @PUT('/posts/{id}/save')
  Future<void> postSave({
    @Path('id') required String id,
  });

  /// 게시글 저장 취소
  @DELETE('/posts/{id}/save')
  Future<void> postUnsave({
    @Path('id') required String id,
  });
}
