// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_feed_request.dart';
import '../models/delete_feeds_request.dart';
import '../models/feed_detail_response.dart';
import '../models/feed_liked_user_response.dart';
import '../models/feed_meta_response.dart';
import '../models/feed_rankings_response.dart';
import '../models/feed_search_sort.dart';
import '../models/following_feeds_response.dart';
import '../models/id_response.dart';
import '../models/latest_feeds_response.dart';
import '../models/searched_feeds_response.dart';
import '../models/update_feed_request.dart';

part 'feeds_api.g.dart';

@RestApi()
abstract class FeedsApi {
  factory FeedsApi(Dio dio, {String? baseUrl}) = _FeedsApi;

  /// 피드 생성
  @POST('/feeds')
  Future<IdResponse> feedCreate({
    @Body() required CreateFeedRequest body,
  });

  /// 피드 여러개 삭제
  @POST('/feeds/batch-delete')
  Future<void> feedDeleteMany({
    @Body() required DeleteFeedsRequest body,
  });

  /// 피드 검색 - Optional Guard.
  ///
  /// [cursor] - 없으면 처음부터.
  ///
  /// [keyword] - 2~20.
  @GET('/feeds/search')
  Future<SearchedFeedsResponse> feedSearch({
    @Query('keyword') required String keyword,
    @Query('sort') required FeedSearchSort sort,
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 랭킹 조회 - Optional Guard.
  ///
  /// [month] - month가 있으면 month 우선적용, month랑 (startDate, endDate) 둘 다 없으면 400에러입니다.
  @GET('/feeds/rankings')
  Future<FeedRankingsResponse> feedGetFeedRanks({
    @Query('month') String? month,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });

  /// 최신순 그림 목록 조회, 무한스크롤 - Optional Guard.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/feeds/latest')
  Future<LatestFeedsResponse> feedGetFeeds({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 팔로잉한 유저들의 피드 목록 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/feeds/following')
  Future<FollowingFeedsResponse> feedGetFollowingFeeds({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 피드 상세 조회 - Optional Guard
  @GET('/feeds/{id}')
  Future<FeedDetailResponse> feedGetFeed({
    @Path('id') required String id,
  });

  /// 피드 수정
  @PUT('/feeds/{id}')
  Future<void> feedUpdate({
    @Path('id') required String id,
    @Body() required UpdateFeedRequest body,
  });

  /// 피드 삭제
  @DELETE('/feeds/{id}')
  Future<void> feedDelete({
    @Path('id') required String id,
  });

  /// 피드 메타데이터 조회
  @GET('/feeds/{id}/meta')
  Future<FeedMetaResponse> feedGetFeedMeta({
    @Path('id') required String id,
  });

  /// 좋아요 누른 유저 목록 조회
  @Deprecated('This method is marked as deprecated')
  @GET('/feeds/{id}/like')
  Future<List<FeedLikedUserResponse>> feedGetLikeUsers({
    @Path('id') required String id,
  });

  /// like
  @PUT('/feeds/{id}/like')
  Future<void> feedLike({
    @Path('id') required String id,
  });

  /// unlike
  @DELETE('/feeds/{id}/like')
  Future<void> feedUnlike({
    @Path('id') required String id,
  });

  /// save
  @PUT('/feeds/{id}/save')
  Future<void> feedSave({
    @Path('id') required String id,
  });

  /// unsave
  @DELETE('/feeds/{id}/save')
  Future<void> feedUnsave({
    @Path('id') required String id,
  });

  /// 피드 조회수 증가용 api
  @PUT('/feeds/{id}/view')
  Future<void> feedView({
    @Path('id') required String id,
  });
}
