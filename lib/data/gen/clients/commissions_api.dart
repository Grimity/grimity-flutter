// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_commission_request.dart';
import '../models/id_response.dart';

part 'commissions_api.g.dart';

@RestApi()
abstract class CommissionsApi {
  factory CommissionsApi(Dio dio, {String? baseUrl}) = _CommissionsApi;

  /// 커미션 등록 (본인인증 필요).
  ///
  /// 본인인증이 완료된 유저만 등록 가능. 미인증 시 422 NOT_VERIFIED 반환.
  @POST('/commissions')
  Future<IdResponse> commissionCreate({
    @Body() required CreateCommissionRequest body,
  });

  /// 커미션 수정 (전체 덮어쓰기).
  ///
  /// 본인 소유 커미션을 전체 덮어쓰기로 수정. tags/questions/images/isPublic 모두 body 값으로 교체됨. 미존재/타인 소유/삭제된 커미션이면 404.
  @PUT('/commissions/{id}')
  Future<void> commissionUpdate({
    @Path('id') required String id,
    @Body() required CreateCommissionRequest body,
  });

  /// 커미션 삭제 (soft delete).
  ///
  /// 본인 소유 커미션을 삭제 처리(deletedAt 세팅). 진행 중인 거래는 보존됨. 미존재/타인 소유/이미 삭제된 커미션이면 404.
  @DELETE('/commissions/{id}')
  Future<void> commissionDelete({
    @Path('id') required String id,
  });
}
