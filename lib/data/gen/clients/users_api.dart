// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/check_name_request.dart';
import '../models/commission_notice_response.dart';
import '../models/my_post_response.dart';
import '../models/popular_user_response.dart';
import '../models/searched_users_response.dart';
import '../models/user_feeds_response.dart';
import '../models/user_feeds_sort.dart';
import '../models/user_meta_response.dart';
import '../models/user_profile_response.dart';

part 'users_api.g.dart';

@RestApi()
abstract class UsersApi {
  factory UsersApi(Dio dio, {String? baseUrl}) = _UsersApi;

  /// 닉네임 중복 체크
  @POST('/users/name-check')
  Future<void> userCheckName({
    @Body() required CheckNameRequest body,
  });

  /// 유저 검색.
  ///
  /// [cursor] - 없으면 처음부터.
  ///
  /// [keyword] - 2~20.
  @GET('/users/search')
  Future<SearchedUsersResponse> userSearchUser({
    @Query('keyword') required String keyword,
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 인기 유저 조회
  @GET('/users/popular')
  Future<List<PopularUserResponse>> userGetPopularUsers();

  /// url로 유저 정보 조회 - Optional Guard
  @GET('/users/profile/{url}')
  Future<UserProfileResponse> userGetProfileByUrl({
    @Path('url') required String url,
  });

  /// url로 유저 메타데이터 조회
  @GET('/users/profile/{url}/meta')
  Future<UserMetaResponse> userGetMetaByUrl({
    @Path('url') required String url,
  });

  /// 유저 정보 조회 - Optional Guard
  @GET('/users/{id}')
  Future<UserProfileResponse> userGetUserById({
    @Path('id') required String id,
  });

  /// 유저 메타데이터 조회
  @GET('/users/{id}/meta')
  Future<UserMetaResponse> userGetMeta({
    @Path('id') required String id,
  });

  /// 유저별 피드 조회 - Optional Guard.
  ///
  /// [cursor] - 없으면 처음부터.
  ///
  /// [albumId] - 없으면 전체.
  @GET('/users/{id}/feeds')
  Future<UserFeedsResponse> userGetFeeds({
    @Path('id') required String id,
    @Query('cursor') String? cursor,
    @Query('size') num? size,
    @Query('sort') UserFeedsSort? sort,
    @Query('albumId') String? albumId,
  });

  /// 유저별 게시글 조회 - 일관성을 위해서 경로는 이렇게하지만 accT는 있어야합니다
  @GET('/users/{id}/posts')
  Future<List<MyPostResponse>> userGetPosts({
    @Path('id') required String id,
    @Query('page') num? page = 1,
    @Query('size') num? size = 10,
  });

  /// 유저의 커미션 공지 조회
  @GET('/users/{id}/commission-notice')
  Future<CommissionNoticeResponse> userGetUserCommissionNotice({
    @Path('id') required String id,
  });

  /// 팔로우
  @PUT('/users/{id}/follow')
  Future<void> userFollow({
    @Path('id') required String id,
  });

  /// 언팔로우
  @DELETE('/users/{id}/follow')
  Future<void> userUnfollow({
    @Path('id') required String id,
  });

  /// 차단
  @PUT('/users/{id}/block')
  Future<void> userBlock({
    @Path('id') required String id,
  });

  /// 차단 풀기
  @DELETE('/users/{id}/block')
  Future<void> userUnblock({
    @Path('id') required String id,
  });
}
