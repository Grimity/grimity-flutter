// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_feed_comment_request.dart';
import '../models/parent_feed_comment_response.dart';

part 'feed_comments_api.g.dart';

@RestApi()
abstract class FeedCommentsApi {
  factory FeedCommentsApi(Dio dio, {String? baseUrl}) = _FeedCommentsApi;

  /// 피드 댓글 생성
  @POST('/feed-comments')
  Future<void> feedCommentCreate({
    @Body() required CreateFeedCommentRequest body,
  });

  /// 피드 댓글 조회 - Optional Guard
  @GET('/feed-comments')
  Future<List<ParentFeedCommentResponse>> feedCommentFindAll({
    @Query('feedId') required String feedId,
  });

  /// 피드 댓글 삭제
  @DELETE('/feed-comments/{id}')
  Future<void> feedCommentDeleteOne({
    @Path('id') required String id,
  });

  /// 피드 댓글 좋아요
  @PUT('/feed-comments/{id}/like')
  Future<void> feedCommentLike({
    @Path('id') required String id,
  });

  /// 피드 댓글 좋아요 취소
  @DELETE('/feed-comments/{id}/like')
  Future<void> feedCommentUnlike({
    @Path('id') required String id,
  });
}
