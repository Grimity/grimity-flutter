// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/album_base_response.dart';
import '../models/commission_notice_response.dart';
import '../models/my_blockings_response.dart';
import '../models/my_followers_response.dart';
import '../models/my_followings_response.dart';
import '../models/my_identity_verification_response.dart';
import '../models/my_like_feeds_response.dart';
import '../models/my_like_posts_response.dart';
import '../models/my_profile_response.dart';
import '../models/my_save_posts_response.dart';
import '../models/register_push_token_request.dart';
import '../models/subscription_response.dart';
import '../models/update_background_image_request.dart';
import '../models/update_profile_image_request.dart';
import '../models/update_subscription_request.dart';
import '../models/update_user_request.dart';
import '../models/upsert_commission_notice_request.dart';
import '../models/verify_identity_request.dart';

part 'me_api.g.dart';

@RestApi()
abstract class MeApi {
  factory MeApi(Dio dio, {String? baseUrl}) = _MeApi;

  /// 내 정보 조회
  @GET('/me')
  Future<MyProfileResponse> meGetMe();

  /// 내 정보 변경
  @PUT('/me')
  Future<void> meUpdateProfile({
    @Body() required UpdateUserRequest body,
  });

  /// 회원 탈퇴
  @DELETE('/me')
  Future<void> meDeleteUser();

  /// 프로필 이미지 변경
  @PUT('/me/image')
  Future<void> meUpdateProfileImage({
    @Body() required UpdateProfileImageRequest body,
  });

  /// 프로필 이미지 삭제
  @DELETE('/me/image')
  Future<void> meDeleteProfileImage();

  /// 푸시토큰 등록
  @PUT('/me/push-token')
  Future<void> meRegisterPushToken({
    @Body() required RegisterPushTokenRequest body,
  });

  /// 배경사진 변경
  @PUT('/me/background')
  Future<void> meUpdateBackgroundImage({
    @Body() required UpdateBackgroundImageRequest body,
  });

  /// 배경사진 삭제
  @DELETE('/me/background')
  Future<void> meDeleteBackgroundImage();

  /// 알림 구독 여부 조회
  @GET('/me/subscribe')
  Future<SubscriptionResponse> meGetSubscriptions();

  /// 알림 구독 여부 수정
  @PUT('/me/subscribe')
  Future<void> meUpdateSubscriptions({
    @Body() required UpdateSubscriptionRequest body,
  });

  /// 내 팔로워 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/me/followers')
  Future<MyFollowersResponse> meGetMyFollowers({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 내 팔로잉 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/me/followings')
  Future<MyFollowingsResponse> meGetMyFollowings({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
    @Query('keyword') String? keyword,
  });

  /// 내가 블락한 유저 조회
  @GET('/me/blockings')
  Future<MyBlockingsResponse> meGetMyBlockings();

  /// 내 팔로워 삭제
  @DELETE('/me/followers/{id}')
  Future<void> meDeleteMyFollower({
    @Path('id') required String id,
  });

  /// 내 좋아요한 피드 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/me/like-feeds')
  Future<MyLikeFeedsResponse> meGetMyLikeFeeds({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 내가 저장한 피드 조회.
  ///
  /// [cursor] - 없으면 처음부터.
  @GET('/me/save-feeds')
  Future<MyLikeFeedsResponse> meGetMySaveFeeds({
    @Query('cursor') String? cursor,
    @Query('size') num? size,
  });

  /// 내가 저장한 게시글 조회
  @GET('/me/save-posts')
  Future<MySavePostsResponse> meGetMySavePosts({
    @Query('page') num? page = 1,
    @Query('size') num? size = 10,
  });

  /// 내가 좋아요한 게시글 조회.
  ///
  /// 좋아요한 시각 기준 최신순으로 정렬된다.
  @GET('/me/like-posts')
  Future<MyLikePostsResponse> meGetMyLikePosts({
    @Query('page') num? page = 1,
    @Query('size') num? size = 10,
  });

  /// 내 앨범 목록 조회
  @GET('/me/albums')
  Future<List<AlbumBaseResponse>> meGetMyAlbums();

  /// 본인인증 완료 처리.
  ///
  /// 프론트에서 포트원 SDK로 본인인증을 완료한 후 받은 identityVerificationId를 전달하면, 서버가 포트원 API로 검증/저장한다.
  @POST('/me/identity-verification')
  Future<void> meVerifyIdentity({
    @Body() required VerifyIdentityRequest body,
  });

  /// 내 본인인증 상태 조회
  @GET('/me/identity-verification')
  Future<MyIdentityVerificationResponse> meGetMyIdentityVerification();

  /// 내 커미션 공지 조회
  @GET('/me/commission-notice')
  Future<CommissionNoticeResponse> meGetMyCommissionNotice();

  /// 내 커미션 공지 등록/수정 (본인인증 필요).
  ///
  /// 본인인증이 완료된 유저만 가능. 1인 1공지로 동일 유저가 다시 호출하면 덮어쓴다.
  @PUT('/me/commission-notice')
  Future<CommissionNoticeResponse> meUpsertMyCommissionNotice({
    @Body() required UpsertCommissionNoticeRequest body,
  });

  /// 내 커미션 공지 삭제
  @DELETE('/me/commission-notice')
  Future<void> meDeleteMyCommissionNotice();
}
