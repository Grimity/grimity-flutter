// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notification_response.dart';

part 'notifications_api.g.dart';

@RestApi()
abstract class NotificationsApi {
  factory NotificationsApi(Dio dio, {String? baseUrl}) = _NotificationsApi;

  /// 알림 목록 조회
  @GET('/notifications')
  Future<List<NotificationResponse>> notificationGetAll();

  /// 전체 알림 읽음 처리
  @PUT('/notifications')
  Future<void> notificationReadAll();

  /// 전체 알림 삭제
  @DELETE('/notifications')
  Future<void> notificationDeleteAll();

  /// 개별 알림 읽음 처리
  @PUT('/notifications/{id}')
  Future<void> notificationRead({
    @Path('id') required String id,
  });

  /// 개별 알림 삭제
  @DELETE('/notifications/{id}')
  Future<void> notificationDelete({
    @Path('id') required String id,
  });
}
