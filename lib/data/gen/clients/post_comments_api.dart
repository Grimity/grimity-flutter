// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_post_comment_request.dart';
import '../models/id_response.dart';
import '../models/parent_post_comment_response.dart';

part 'post_comments_api.g.dart';

@RestApi()
abstract class PostCommentsApi {
  factory PostCommentsApi(Dio dio, {String? baseUrl}) = _PostCommentsApi;

  /// 댓글 생성
  @POST('/post-comments')
  Future<IdResponse> postCommentCreatePostComment({
    @Body() required CreatePostCommentRequest body,
  });

  /// 댓글 조회 - Optional Guard
  @GET('/post-comments')
  Future<List<ParentPostCommentResponse>> postCommentGetPostComments({
    @Query('postId') required String postId,
  });

  /// 댓글 삭제
  @DELETE('/post-comments/{id}')
  Future<void> postCommentDeletePostComment({
    @Path('id') required String id,
  });

  /// 댓글 좋아요
  @PUT('/post-comments/{id}/like')
  Future<void> postCommentLikePostComment({
    @Path('id') required String id,
  });

  /// 댓글 좋아요 취소
  @DELETE('/post-comments/{id}/like')
  Future<void> postCommentUnlikePostComment({
    @Path('id') required String id,
  });
}
