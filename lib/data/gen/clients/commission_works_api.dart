// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_commission_review_request.dart';
import '../models/create_commission_work_memo_request.dart';
import '../models/create_commission_work_request.dart';
import '../models/id_response.dart';
import '../models/reject_commission_work_request.dart';
import '../models/upload_commission_work_result_request.dart';

part 'commission_works_api.g.dart';

@RestApi()
abstract class CommissionWorksApi {
  factory CommissionWorksApi(Dio dio, {String? baseUrl}) = _CommissionWorksApi;

  /// 커미션 신청.
  ///
  /// commissionId가 있으면 FORM(폼) 신청, 없으면 DIRECT(직접 의뢰). 신청 시 CommissionWork와 CommissionRequest가 동시에 생성됨.
  @POST('/commission-works')
  Future<IdResponse> commissionWorkCreate({
    @Body() required CreateCommissionWorkRequest body,
  });

  /// 커미션 수락.
  ///
  /// 작가가 받은 PENDING 상태의 신청을 수락. ACCEPTED 상태로 전환.
  @PATCH('/commission-works/{id}/accept')
  Future<IdResponse> commissionWorkAccept({
    @Path('id') required String id,
  });

  /// 커미션 신청 취소.
  ///
  /// 신청자(의뢰인)가 본인이 보낸 PENDING 상태의 신청을 취소. CANCELED 상태로 전환. 작가가 이미 수락/거절했으면 409.
  @PATCH('/commission-works/{id}/cancel')
  Future<IdResponse> commissionWorkCancel({
    @Path('id') required String id,
  });

  /// 커미션 작업 완료.
  ///
  /// 신청자(의뢰인)가 작업을 완료 처리. ACCEPTED/IN_PROGRESS/FINAL 상태에서 COMPLETED로 전환.
  @PATCH('/commission-works/{id}/complete')
  Future<IdResponse> commissionWorkComplete({
    @Path('id') required String id,
  });

  /// 커미션 거절.
  ///
  /// 작가가 받은 PENDING 상태의 신청을 거절. 거절 사유는 선택.
  @PATCH('/commission-works/{id}/reject')
  Future<IdResponse> commissionWorkReject({
    @Path('id') required String id,
    @Body() required RejectCommissionWorkRequest body,
  });

  /// 작업물 업로드 (덮어쓰기).
  ///
  /// 작가가 작업물 이미지를 업로드. 기존 작업물 전체를 덮어씀. 작업물이 있으면 IN_PROGRESS, 최종 체크 시 FINAL로 전환. 종료 상태(REJECTED/CANCELED/COMPLETED)면 409.
  @PUT('/commission-works/{id}/result')
  Future<IdResponse> commissionWorkUploadResult({
    @Path('id') required String id,
    @Body() required UploadCommissionWorkResultRequest body,
  });

  /// 작업 메모 작성.
  ///
  /// 작가가 해당 커미션 작업에 메모를 작성. 메모는 의뢰인에게 노출됨. 여러 개 작성 가능.
  @POST('/commission-works/{id}/memos')
  Future<IdResponse> commissionWorkCreateMemo({
    @Path('id') required String id,
    @Body() required CreateCommissionWorkMemoRequest body,
  });

  /// 커미션 후기(유저 평가) 작성.
  ///
  /// COMPLETED 상태의 커미션에 대해 의뢰인/작가가 상대방에게 후기를 작성. 한 사람당 1회만 작성 가능.
  @POST('/commission-works/{id}/reviews')
  Future<IdResponse> commissionWorkCreateReview({
    @Path('id') required String id,
    @Body() required CreateCommissionReviewRequest body,
  });
}
